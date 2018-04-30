/*
  From https://www.mycplus.com/source-code/c-source-code/base64-encode-decode/
  License: ISC license (a simplified version of the BSD license that is
  functionally identical). As such, it may legitimately be reused in any
  project, whether Proprietary or Open Source.
  See: https://www.mycplus.com/source-code/c-source-code/algorithm-data-structures-implementation/

  Modified for XSB: Michael Kifer

  Another possible version to consider is https://github.com/littlstar/b64.c
*/

#include "xsb_config.h"
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <string.h>
#include <errno.h>

#ifdef WIN_NT
#include <windows.h>
#include <direct.h>
#include <io.h>
#include <stdarg.h>
#else /* Unix */
#include <unistd.h>
#include <sys/uio.h>
#endif

#include "auxlry.h"
#include "cell_xsb.h"
#include "error_xsb.h"
#include "builtin.h"
#include "cinterf.h"
 
static char encoding_table[] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
                                'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
                                'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                                'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
                                'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
                                'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
                                'w', 'x', 'y', 'z', '0', '1', '2', '3',
                                '4', '5', '6', '7', '8', '9', '+', '/'};
static char *decoding_table = NULL;
static int mod_table[] = {0, 2, 1};
 
// Prototypes
char *base64_encode_string(const unsigned char *, size_t, size_t *);
unsigned char *base64_decode_string(const char *, size_t, size_t *);
void base64_cleanup();
void build_decoding_table();


int base64_encode(prolog_term InputTerm, prolog_term Output)
{
  size_t out_size = 0, in_size= 0, result_size = 0;
  int retcode;
  struct stat stat_buff;
  unsigned char *InStr;
  char *Result;
  int unify_code;

  if (isstring(InputTerm) && !is_list(InputTerm)) {
    InStr = (unsigned char *) string_val(InputTerm);
    Result = base64_encode_string(InStr, strlen((char *)InStr), &out_size);
    unify_code = p2p_unify(makestring(string_find(Result,1)),Output);

    result_size = strlen(Result);
    if (result_size < out_size) {
      // It is impossible to know the true size of InStr if it is an atom that
      // has a null character like in 'abcd\x0\67'.
      // So this condition is never true. Keeping it in case we figure it out.
      xsb_warn("b64_enc: Input string has a null-symbol\n\tand cannot be losslessly encoded as an atom.\n\tLossless encoding is supported only for file content.");
      fprintf(stderr, "\tFull encoded size: %d; actually encoded: %d\n",
              (int)out_size, (int)result_size);
    }

    free(Result);
    //base64_cleanup();
    return unify_code;

  } else if (isconstr(InputTerm) && strcmp(p2c_functor(InputTerm),"file")==0) {
    char *filename = string_val(p2p_arg(InputTerm,1));
    FILE *fp;                // File pointer for reading files
    unsigned char c;         // Character read from file
    int pos = 0;

    retcode = stat(filename, &stat_buff);
    if (retcode != 0) {
      fprintf(stderr, "b64_enc: can't get size of file %s\n", filename);
      return FALSE;
    }
    in_size = stat_buff.st_size;

    InStr = malloc(in_size);

    if (!(fp = fopen(filename,"rb"))) {
      fprintf(stderr, "b64_enc: unable to open file %s\n", filename);
      return FALSE;
    }
    // alloc array of file_size
    c = fgetc(fp);
    while(!feof(fp) && pos < in_size) {
      // add character to data
      InStr[pos] = c;
      c = fgetc(fp);
      pos++;
    }
    fclose(fp);

    Result = base64_encode_string(InStr, in_size, &out_size);
    unify_code = p2p_unify(makestring(string_find(Result,1)),Output);

    free(Result);
    free(InStr);
    //base64_cleanup();
    return unify_code;

  } else if (is_list(InputTerm)) {
    // unimplemented
    return FALSE;
  }
  return FALSE; // to pacify the compiler
}

int base64_decode(prolog_term InputTerm, prolog_term Output)
{
  size_t out_size = 0, result_size = 0;
  char *InStr;
  unsigned char *Result;
  int unify_code;

  InStr = string_val(InputTerm);

  if (isstring(Output) || is_var(Output)
      || (isconstr(Output) && strcmp(p2c_functor(Output),"atom")==0)) {
    Result = base64_decode_string(InStr, strlen(InStr), &out_size);
    unify_code = p2p_unify(makestring(string_find((char *)Result,1)),Output);

    result_size = strlen((char *)Result);
    if (result_size < out_size) {
      xsb_warn("b64_dec: Decoded string has a null-symbol\n\tand cannot be losslessly decoded as an atom.\n\tLossless decoding is supported only for file output.");
      fprintf(stderr, "\tFull decoded size: %d; actually decoded: %d\n",
              (int)out_size, (int)result_size);
    }

    free(Result);
    //base64_cleanup();
    return unify_code;

  } else if (isconstr(Output) && strcmp(p2c_functor(Output),"file")==0) {
    char *filename = string_val(p2p_arg(Output,1));
    FILE *fp;                // File pointer for reading files
    unsigned char c;         // Character read from file
    int pos = 0;

    if (!(fp = fopen(filename,"wb"))) {
      fprintf(stderr, "b64_dec: unable to open file %s\n", filename);
      return FALSE;
    }

    Result = base64_decode_string(InStr, strlen(InStr), &out_size);

    while(pos < out_size) {
      // add character to file
      c = Result[pos];
      fputc(c,fp);
      pos++;
    }
    fclose(fp);

    free(Result);
    //base64_cleanup();
    return TRUE;

  } else if (isconstr(Output) && strcmp(p2c_functor(Output),"list")==0) {
    // unimplemented
    return FALSE;
  }
  return FALSE; // to pacify the compiler
}

 
char *base64_encode_string(const unsigned char *data,
                           size_t input_length,
                           size_t *output_length)
{
 
  *output_length = 4 * ((input_length + 2) / 3);
 
  char *encoded_data = malloc(1+*output_length);
  if (encoded_data == NULL) return NULL;
 
  for (int i = 0, j = 0; i < input_length;) {
 
    uint32_t octet_a = i < input_length ? (unsigned char)data[i++] : 0;
    uint32_t octet_b = i < input_length ? (unsigned char)data[i++] : 0;
    uint32_t octet_c = i < input_length ? (unsigned char)data[i++] : 0;
    
    uint32_t triple = (octet_a << 0x10) + (octet_b << 0x08) + octet_c;
    
    encoded_data[j++] = encoding_table[(triple >> 3 * 6) & 0x3F];
    encoded_data[j++] = encoding_table[(triple >> 2 * 6) & 0x3F];
    encoded_data[j++] = encoding_table[(triple >> 1 * 6) & 0x3F];
    encoded_data[j++] = encoding_table[(triple >> 0 * 6) & 0x3F];
  }
  
  for (int i = 0; i < mod_table[input_length % 3]; i++)
    encoded_data[*output_length - 1 - i] = '=';

  // if output is atom, we need to NULL-terminate it, for Prolog
  encoded_data[*output_length] = '\0';
  
  return encoded_data;
}
 
 
unsigned char *base64_decode_string(const char *data,
                                    size_t input_length,
                                    size_t *output_length)
{
 
  if (decoding_table == NULL) build_decoding_table();
  
  if (input_length % 4 != 0) return NULL;
  
  *output_length = input_length / 4 * 3;
  if (data[input_length - 1] == '=') (*output_length)--;
  if (data[input_length - 2] == '=') (*output_length)--;
  
  unsigned char *decoded_data = malloc(1+*output_length);
  if (decoded_data == NULL) return NULL;
  
  for (int i = 0, j = 0; i < input_length;) {
    
    uint32_t sextet_a =
      data[i] == '=' ? 0 & i++ : decoding_table[(int)data[i++]];
    uint32_t sextet_b =
      data[i] == '=' ? 0 & i++ : decoding_table[(int)data[i++]];
    uint32_t sextet_c =
      data[i] == '=' ? 0 & i++ : decoding_table[(int)data[i++]];
    uint32_t sextet_d =
      data[i] == '=' ? 0 & i++ : decoding_table[(int)data[i++]];
    
    uint32_t triple = (sextet_a << 3 * 6)
      + (sextet_b << 2 * 6)
      + (sextet_c << 1 * 6)
      + (sextet_d << 0 * 6);
    
    if (j < *output_length) decoded_data[j++] = (triple >> 2 * 8) & 0xFF;
    if (j < *output_length) decoded_data[j++] = (triple >> 1 * 8) & 0xFF;
    if (j < *output_length) decoded_data[j++] = (triple >> 0 * 8) & 0xFF;
  }
  
  // if output is atom, we need to NULL-terminate it, for Prolog
  decoded_data[*output_length] = '\0';

  return decoded_data;
}
 
 
void build_decoding_table() {
 
  decoding_table = malloc(256);
  
  for (int i = 0; i < 64; i++)
    decoding_table[(unsigned char) encoding_table[i]] = i;
}

 
void base64_cleanup() {
  free(decoding_table);
}
