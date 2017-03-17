*----------------------------------------------------------------------*
*       CLASS ZCL_AES_UTILITY DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class ZCL_AES_UTILITY definition
  public
  final
  create public .

public section.

*"* public components of class ZCL_AES_UTILITY
*"* do not include other source files here!!!
  constants MC_BLOCK_LENGTH_IN_BIT type INT4 value 128 ##NO_TEXT.
  constants MC_BLOCK_LENGTH_IN_BYTE type INT4 value 16 ##NO_TEXT.
  constants MC_KEY_LENGTH_IN_BIT_128 type INT4 value 128 ##NO_TEXT.
  constants MC_KEY_LENGTH_IN_BIT_192 type INT4 value 192 ##NO_TEXT.
  constants MC_KEY_LENGTH_IN_BIT_256 type INT4 value 256 ##NO_TEXT.
  constants MC_ENCRYPTION_MODE_ECB type CHAR10 value 'ECB' ##NO_TEXT.
  constants MC_ENCRYPTION_MODE_CBC type CHAR10 value 'CBC' ##NO_TEXT.
  constants MC_ENCRYPTION_MODE_PCBC type CHAR10 value 'PCBC' ##NO_TEXT.
  constants MC_ENCRYPTION_MODE_CFB type CHAR10 value 'CFB' ##NO_TEXT.
  constants MC_ENCRYPTION_MODE_OFB type CHAR10 value 'OFB' ##NO_TEXT.
  constants MC_ENCRYPTION_MODE_CTR type CHAR10 value 'CTR' ##NO_TEXT.
  constants MC_PADDING_STANDARD_NONE type CHAR10 value 'NONE' ##NO_TEXT.
  constants MC_PADDING_STANDARD_PKCS_5 type CHAR10 value 'PKCS5' ##NO_TEXT.
  constants MC_PADDING_STANDARD_PKCS_7 type CHAR10 value 'PKCS7' ##NO_TEXT.
  class-data:
    mt_raw16 TYPE TABLE OF zif_aes_mode=>ty_raw16 .

  class-methods IS_VALID_IV_XSTRING
    importing
      !I_INITIALIZATION_VECTOR type XSTRING
    returning
      value(R_VALID) type BOOLE_D .
  class-methods ENCRYPT_XSTRING
    importing
      !I_KEY type XSTRING
      !I_DATA type XSTRING
      !I_INITIALIZATION_VECTOR type XSTRING optional
      !I_PADDING_STANDARD type CHAR10 optional
      !I_ENCRYPTION_MODE type CHAR10 optional
    exporting
      !E_DATA type XSTRING .
  class-methods DECRYPT_XSTRING
    importing
      !I_KEY type XSTRING
      !I_DATA type XSTRING
      !I_INITIALIZATION_VECTOR type XSTRING optional
      !I_PADDING_STANDARD type CHAR10 optional
      !I_ENCRYPTION_MODE type CHAR10 optional
    exporting
      !E_DATA type XSTRING .
  class-methods ENCRYPT_RAW16_TABLE
    importing
      !I_KEY type XSTRING
      !I_INITIALIZATION_VECTOR type XSTRING optional
      !I_ENCRYPTION_MODE type CHAR10 optional
      !I_PADDING_STANDARD type CHAR10 optional
      !I_DATA_LENGTH_IN_BYTE type INT4
    exporting
      !ET_DATA like MT_RAW16
    changing
      !CT_DATA like MT_RAW16 .
  class-methods DECRYPT_RAW16_TABLE
    importing
      !I_KEY type XSTRING
      !I_INITIALIZATION_VECTOR type XSTRING
      !I_ENCRYPTION_MODE type CHAR10
      !I_PADDING_STANDARD type CHAR10
      !IT_DATA like MT_RAW16
    exporting
      !E_DATA_LENGTH_IN_BYTE type INT4
      !ET_DATA like MT_RAW16 .
  class-methods CONVERT_XSTRING_TO_RAW16_TABLE
    importing
      !I_DATA type XSTRING
    exporting
      !E_DATA_LENGTH_IN_BYTE type INT4
      !ET_RAW16_TABLE like MT_RAW16 .
  class-methods CONVERT_RAW16_TABLE_TO_XSTRING
    importing
      !I_DATA_LENGTH_IN_BYTE type INT4
      !IT_RAW16_TABLE like MT_RAW16
    exporting
      !E_DATA type XSTRING .
  class-methods VALIDATE_ENCRYPTION_MODE
    importing
      !I_INITIALIZATION_VECTOR type XSTRING optional
      !I_ENCRYPTION_MODE type CHAR10 optional .
  class-methods VALIDATE_PADDING_STANDARD
    importing
      !I_PADDING_STANDARD type CHAR10 optional .
  class-methods VALIDATE_RAW16_TABLE_SIZE
    importing
      !I_DATA_LENGTH_IN_BYTE type INT4
      !IT_DATA like MT_RAW16 .
  class-methods ADD_PADDING_RAW16_TABLE
    importing
      !I_DATA_LENGTH_IN_BYTE type INT4
      !IO_PADDING_UTILITY type ref to ZCL_BYTE_PADDING_UTILITY
    changing
      !CT_DATA like MT_RAW16 .
  class-methods REMOVE_PADDING_RAW16_TABLE
    importing
      !IO_PADDING_UTILITY type ref to ZCL_BYTE_PADDING_UTILITY
    exporting
      !E_DATA_LENGTH_IN_BYTE type INT4
    changing
      !CT_DATA like MT_RAW16 .
protected section.

*"* protected components of class ZCL_AES_UTILITY
*"* do not include other source files here!!!
  class-data MO_RIJNDAEL_128_128 type ref to ZCL_RIJNDAEL_UTILITY .
  class-data MO_RIJNDAEL_128_192 type ref to ZCL_RIJNDAEL_UTILITY .
  class-data MO_RIJNDAEL_128_256 type ref to ZCL_RIJNDAEL_UTILITY .
  class-data MO_PADDING_UTILITY_NONE type ref to ZCL_BYTE_PADDING_UTILITY .
  class-data MO_PADDING_UTILITY_PKCS_5 type ref to ZCL_BYTE_PADDING_UTILITY .
  class-data MO_PADDING_UTILITY_PKCS_7 type ref to ZCL_BYTE_PADDING_UTILITY .
  class-data MO_AES_MODE_CBC type ref to ZIF_AES_MODE .
  class-data MO_AES_MODE_PCBC type ref to ZIF_AES_MODE .
  class-data MO_AES_MODE_OFB type ref to ZIF_AES_MODE .
  class-data MO_AES_MODE_CFB type ref to ZIF_AES_MODE .
  class-data MO_AES_MODE_CTR type ref to ZIF_AES_MODE .
  class-data MO_AES_MODE_ECB type ref to ZIF_AES_MODE .

  class-methods GET_RIJNDAEL
    importing
      !I_KEY type XSTRING
    returning
      value(R_RAJNDAEL) type ref to ZCL_RIJNDAEL_UTILITY .
  class-methods GET_PADDING_UTILITY
    importing
      !I_PADDING_STANDARD type CHAR10 optional
    returning
      value(R_PADDING_UTILITY) type ref to ZCL_BYTE_PADDING_UTILITY .
  class-methods GET_AES_MODE
    importing
      !I_ENCRYPTION_MODE type CHAR10
    returning
      value(R_AES_MODE) type ref to ZIF_AES_MODE .
  PRIVATE SECTION.
*"* private components of class ZCL_AES_UTILITY
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_AES_UTILITY IMPLEMENTATION.


  METHOD add_padding_raw16_table.
    DATA: lv_last_line_length       TYPE int4,
          lv_last_line_number       TYPE int4,
          lv_line_before_padding    TYPE xstring,
          lv_line_after_padding     TYPE xstring,
          lv_padding_length_in_byte TYPE int4.

    FIELD-SYMBOLS: <raw16>          TYPE zif_aes_mode=>ty_raw16.

    lv_last_line_length = i_data_length_in_byte MOD mc_block_length_in_byte.

    IF lv_last_line_length = 0.
      io_padding_utility->add_padding(
        EXPORTING
          i_block_length_in_byte    = mc_block_length_in_byte
          i_data                    = lv_line_before_padding
        IMPORTING
          e_padding_length_in_byte  = lv_padding_length_in_byte
          e_data                    = lv_line_after_padding ).

      IF lv_padding_length_in_byte > 0.
        APPEND INITIAL LINE TO ct_data ASSIGNING <raw16>.
        <raw16> = lv_line_after_padding.
      ENDIF.

    ELSE.
      lv_last_line_number = lines( ct_data ).
      READ TABLE ct_data INDEX lv_last_line_number ASSIGNING <raw16>.
      lv_line_before_padding = <raw16>+0(lv_last_line_length).

      io_padding_utility->add_padding(
      EXPORTING
        i_block_length_in_byte    = mc_block_length_in_byte
        i_data                    = lv_line_before_padding
      IMPORTING
        e_padding_length_in_byte  = lv_padding_length_in_byte
        e_data                    = lv_line_after_padding ).

      <raw16> = lv_line_after_padding.

    ENDIF.

  ENDMETHOD.                    "add_padding_raw16_table


  METHOD convert_raw16_table_to_xstring.
    DATA: lv_last_line_length   TYPE int4.
    FIELD-SYMBOLS: <raw16>      TYPE zif_aes_mode=>ty_raw16.

    CLEAR e_data.

    IF i_data_length_in_byte <= 0.
      RETURN.
    ENDIF.

    lv_last_line_length = ( i_data_length_in_byte - 1 ) MOD mc_block_length_in_byte + 1.

    LOOP AT it_raw16_table ASSIGNING <raw16>.
      AT LAST.
        e_data = e_data && <raw16>(lv_last_line_length).
        EXIT.
      ENDAT.

      e_data = e_data && <raw16>.
    ENDLOOP.

  ENDMETHOD.                    "convert_raw16_table_to_xstring


  METHOD convert_xstring_to_raw16_table.
    DATA: lv_input_length     TYPE int4,
          lv_number_of_blocks TYPE int4,
          lv_block_cursor     TYPE int4,
          lv_offset           TYPE int4.

    FIELD-SYMBOLS: <raw16>      TYPE zif_aes_mode=>ty_raw16.

    CLEAR et_raw16_table.

    lv_input_length = xstrlen( i_data ).
    lv_number_of_blocks = ceil( '1.0' * lv_input_length / mc_block_length_in_byte ).

    lv_block_cursor = 1.
    lv_offset = 0.
    WHILE lv_block_cursor <= lv_number_of_blocks.
      APPEND INITIAL LINE TO et_raw16_table ASSIGNING <raw16>.

      IF lv_block_cursor < lv_number_of_blocks.
        <raw16> = i_data+lv_offset(mc_block_length_in_byte).
      ELSE.
        <raw16> = i_data+lv_offset.
      ENDIF.

      lv_block_cursor = lv_block_cursor + 1.
      lv_offset = lv_offset + mc_block_length_in_byte.
    ENDWHILE.

    e_data_length_in_byte = lv_input_length.

  ENDMETHOD.                    "convert_xstring_to_raw16_table


  METHOD decrypt_raw16_table.
    DATA: rijndael                TYPE REF TO zcl_rijndael_utility.
    DATA: padding_utility         TYPE REF TO zcl_byte_padding_utility.
    DATA: aes_mode                TYPE REF TO zif_aes_mode.

    CLEAR et_data.

    validate_encryption_mode(
        i_encryption_mode       = i_encryption_mode
        i_initialization_vector = i_initialization_vector ).

    validate_padding_standard( i_padding_standard ).

    rijndael = get_rijndael( i_key ).
    padding_utility = get_padding_utility( i_padding_standard ).
    aes_mode = get_aes_mode( i_encryption_mode ).

    aes_mode->decrypt_raw16_table(
      EXPORTING
        io_rijndael             = rijndael
        i_key                   = i_key
        i_initialization_vector = i_initialization_vector
        it_data                 = it_data
      IMPORTING
        et_data                 = et_data ).

    remove_padding_raw16_table(
      EXPORTING
        io_padding_utility      = padding_utility
      IMPORTING
        e_data_length_in_byte   = e_data_length_in_byte
      CHANGING
        ct_data                 = et_data ).

  ENDMETHOD.                    "DECRYPT_RAW16_TABLE


  METHOD decrypt_xstring.
    DATA: lt_plain_raw16           LIKE mt_raw16,
          lt_cipher_raw16          LIKE mt_raw16,
          lv_plain_length_in_byte  TYPE int4.

    CLEAR e_data.

    convert_xstring_to_raw16_table(
      EXPORTING
        i_data      = i_data
      IMPORTING
        et_raw16_table        = lt_cipher_raw16 ).

    decrypt_raw16_table(
      EXPORTING
        i_encryption_mode       = i_encryption_mode
        i_initialization_vector = i_initialization_vector
        i_padding_standard      = i_padding_standard
        i_key                   = i_key
        it_data                 = lt_cipher_raw16
      IMPORTING
        e_data_length_in_byte   = lv_plain_length_in_byte
        et_data                 = lt_plain_raw16 ).

    convert_raw16_table_to_xstring(
      EXPORTING
        it_raw16_table          = lt_plain_raw16
        i_data_length_in_byte   = lv_plain_length_in_byte
      IMPORTING
        e_data                  = e_data ).

  ENDMETHOD.                    "decrypt_xstring


  METHOD encrypt_raw16_table.
    DATA: rijndael                TYPE REF TO zcl_rijndael_utility.
    DATA: padding_utility         TYPE REF TO zcl_byte_padding_utility.
    DATA: aes_mode                TYPE REF TO zif_aes_mode.

    CLEAR et_data.

    validate_encryption_mode(
        i_encryption_mode       = i_encryption_mode
        i_initialization_vector = i_initialization_vector ).

    validate_padding_standard( i_padding_standard ).

    validate_raw16_table_size(
        it_data                 = ct_data
        i_data_length_in_byte   = i_data_length_in_byte ).

    rijndael = get_rijndael( i_key ).
    padding_utility = get_padding_utility( i_padding_standard ).
    aes_mode = get_aes_mode( i_encryption_mode ).

    add_padding_raw16_table(
      EXPORTING
        i_data_length_in_byte   = i_data_length_in_byte
        io_padding_utility      = padding_utility
      CHANGING
        ct_data                 = ct_data ).

    aes_mode->encrypt_raw16_table(
      EXPORTING
        io_rijndael             = rijndael
        i_key                   = i_key
        i_initialization_vector = i_initialization_vector
        it_data                 = ct_data
      IMPORTING
        et_data                 = et_data ).

  ENDMETHOD.                    "encrypt_raw16_table


  METHOD encrypt_xstring.
    DATA: lt_plain_raw16           LIKE mt_raw16,
          lt_cipher_raw16          LIKE mt_raw16,
          lv_plain_length_in_byte  TYPE int4,
          lv_cipher_length_in_byte TYPE int4.

    CLEAR e_data.

    convert_xstring_to_raw16_table(
      EXPORTING
        i_data      = i_data
      IMPORTING
        e_data_length_in_byte = lv_plain_length_in_byte
        et_raw16_table        = lt_plain_raw16 ).

    encrypt_raw16_table(
      EXPORTING
        i_data_length_in_byte   = lv_plain_length_in_byte
        i_encryption_mode       = i_encryption_mode
        i_initialization_vector = i_initialization_vector
        i_padding_standard      = i_padding_standard
        i_key                   = i_key
      IMPORTING
        et_data                 = lt_cipher_raw16
      CHANGING
        ct_data                 = lt_plain_raw16 ).

    lv_cipher_length_in_byte = lines( lt_cipher_raw16 ) * mc_block_length_in_byte.

    convert_raw16_table_to_xstring(
      EXPORTING
        it_raw16_table          = lt_cipher_raw16
        i_data_length_in_byte   = lv_cipher_length_in_byte
      IMPORTING
        e_data                  = e_data ).

  ENDMETHOD.                    "encrypt_xstring


  METHOD get_aes_mode.
    CASE i_encryption_mode.
      WHEN space OR mc_encryption_mode_ecb.
        IF mo_aes_mode_ecb IS NOT BOUND.
          CREATE OBJECT mo_aes_mode_ecb TYPE zcl_aes_mode_ecb.
        ENDIF.
        r_aes_mode = mo_aes_mode_ecb.

      WHEN mc_encryption_mode_cbc.
        IF mo_aes_mode_cbc IS NOT BOUND.
          CREATE OBJECT mo_aes_mode_cbc TYPE zcl_aes_mode_cbc.
        ENDIF.
        r_aes_mode = mo_aes_mode_cbc.

      WHEN mc_encryption_mode_pcbc.
        IF mo_aes_mode_pcbc IS NOT BOUND.
          CREATE OBJECT mo_aes_mode_pcbc TYPE zcl_aes_mode_pcbc.
        ENDIF.
        r_aes_mode = mo_aes_mode_pcbc.

      WHEN mc_encryption_mode_cfb.
        IF mo_aes_mode_cfb IS NOT BOUND.
          CREATE OBJECT mo_aes_mode_cfb TYPE zcl_aes_mode_cfb.
        ENDIF.
        r_aes_mode = mo_aes_mode_cfb.

      WHEN mc_encryption_mode_ofb.
        IF mo_aes_mode_ofb IS NOT BOUND.
          CREATE OBJECT mo_aes_mode_ofb TYPE zcl_aes_mode_ofb.
        ENDIF.
        r_aes_mode = mo_aes_mode_ofb.

      WHEN mc_encryption_mode_ctr.
        IF mo_aes_mode_ctr IS NOT BOUND.
          CREATE OBJECT mo_aes_mode_ctr TYPE zcl_aes_mode_ctr.
        ENDIF.
        r_aes_mode = mo_aes_mode_ctr.

    ENDCASE.

  ENDMETHOD.                    "get_aes_mode


  METHOD get_padding_utility.
    CASE i_padding_standard.
      WHEN space OR zcl_byte_padding_utility=>mc_padding_standard_none.
        IF mo_padding_utility_none IS NOT BOUND.
          mo_padding_utility_none = zcl_byte_padding_utility=>get_byte_padding_utility( i_padding_standard ).
        ENDIF.
        r_padding_utility = mo_padding_utility_none.

       WHEN zcl_byte_padding_utility=>mc_padding_standard_pkcs_5.
        IF mo_padding_utility_pkcs_5 IS NOT BOUND.
          mo_padding_utility_pkcs_5 = zcl_byte_padding_utility=>get_byte_padding_utility( i_padding_standard ).
        ENDIF.
        r_padding_utility = mo_padding_utility_pkcs_5.

      WHEN zcl_byte_padding_utility=>mc_padding_standard_pkcs_7.
        IF mo_padding_utility_pkcs_7 IS NOT BOUND.
          mo_padding_utility_pkcs_7 = zcl_byte_padding_utility=>get_byte_padding_utility( i_padding_standard ).
        ENDIF.
        r_padding_utility = mo_padding_utility_pkcs_7.

    ENDCASE.
  ENDMETHOD.                    "get_padding_utility


  METHOD get_rijndael.
    DATA: key_length_in_bit   TYPE int4.

    key_length_in_bit = xstrlen( i_key ) * zcl_rijndael_utility=>mc_factor_bit_byte.

    IF key_length_in_bit = mc_key_length_in_bit_128.
      IF mo_rijndael_128_128 IS NOT BOUND.
        CREATE OBJECT mo_rijndael_128_128
          EXPORTING
            i_key_length_in_bit   = mc_key_length_in_bit_128
            i_block_length_in_bit = mc_block_length_in_bit.
      ENDIF.

      r_rajndael = mo_rijndael_128_128.

    ELSEIF key_length_in_bit = mc_key_length_in_bit_192.
      IF mo_rijndael_128_192 IS NOT BOUND.
        CREATE OBJECT mo_rijndael_128_192
          EXPORTING
            i_key_length_in_bit   = mc_key_length_in_bit_192
            i_block_length_in_bit = mc_block_length_in_bit.
      ENDIF.

      r_rajndael = mo_rijndael_128_192.

    ELSEIF key_length_in_bit = mc_key_length_in_bit_256.
      IF mo_rijndael_128_256 IS NOT BOUND.
        CREATE OBJECT mo_rijndael_128_256
          EXPORTING
            i_key_length_in_bit   = mc_key_length_in_bit_256
            i_block_length_in_bit = mc_block_length_in_bit.
      ENDIF.

      r_rajndael = mo_rijndael_128_256.

    ELSE.
      RAISE EXCEPTION TYPE cx_me_illegal_argument
        EXPORTING
          name  = 'I_KEY'
          value = 'Incorrect key length'.
    ENDIF.

  ENDMETHOD.                    "get_rijndael


  METHOD is_valid_iv_xstring.
    DATA: iv_length_in_bit   TYPE int4.

    iv_length_in_bit = xstrlen( i_initialization_vector ) * zcl_rijndael_utility=>mc_factor_bit_byte.

    IF iv_length_in_bit = mc_block_length_in_bit.
      r_valid = abap_true.
    ENDIF.

  ENDMETHOD.                    "is_valid_iv_xstring


  METHOD remove_padding_raw16_table.
    DATA: lv_padding_length      TYPE int4,
          lv_last_line_number    TYPE int4,
          lv_line_before_padding TYPE xstring,
          lv_line_after_padding  TYPE xstring.

    FIELD-SYMBOLS: <raw16> TYPE zif_aes_mode=>ty_raw16.

    CLEAR e_data_length_in_byte.

    lv_last_line_number = lines( ct_data ).
    IF lv_last_line_number <= 0.
      RETURN.
    ENDIF.

    READ TABLE ct_data INDEX lv_last_line_number ASSIGNING <raw16>.
    lv_line_after_padding = <raw16>.

    io_padding_utility->remove_padding(
      EXPORTING
        i_block_length_in_byte    = mc_block_length_in_byte
        i_data                    = lv_line_after_padding
      IMPORTING
        e_padding_length_in_byte  = lv_padding_length
        e_data                    = lv_line_before_padding ).

    IF lv_line_before_padding IS INITIAL.
      DELETE ct_data INDEX lv_last_line_number.
    ELSE.
      <raw16> = lv_line_before_padding.
    ENDIF.

    e_data_length_in_byte = lv_last_line_number * mc_block_length_in_byte - lv_padding_length.

  ENDMETHOD.                    "remove_padding_raw16_table


  METHOD validate_encryption_mode.

    IF i_encryption_mode = mc_encryption_mode_cbc
        OR i_encryption_mode = mc_encryption_mode_pcbc
        OR i_encryption_mode = mc_encryption_mode_cfb
        OR i_encryption_mode = mc_encryption_mode_ofb
        OR i_encryption_mode = mc_encryption_mode_ctr.
      IF is_valid_iv_xstring( i_initialization_vector ) = abap_false.
        RAISE EXCEPTION TYPE cx_me_illegal_argument
          EXPORTING
            name  = 'I_INITIALIZATION_VECTOR'
            value = 'Incorrect Initialization Vector length'.
      ENDIF.

    ELSEIF i_encryption_mode = mc_encryption_mode_ecb
          OR i_encryption_mode IS INITIAL.
      "Nothing, default is ECB mode

    ELSE.
      RAISE EXCEPTION TYPE cx_me_illegal_argument
        EXPORTING
          name  = 'I_ENCRYPTION_MODE'
          value = 'Incorrect Encryption Mode'.

    ENDIF.

  ENDMETHOD.                    "validate_encryption_mode


  METHOD validate_padding_standard.

    IF  i_padding_standard IS NOT INITIAL AND
        i_padding_standard <> zcl_byte_padding_utility=>mc_padding_standard_none AND
        i_padding_standard <> zcl_byte_padding_utility=>mc_padding_standard_pkcs_5 AND
        i_padding_standard <> zcl_byte_padding_utility=>mc_padding_standard_pkcs_7.

      RAISE EXCEPTION TYPE cx_me_illegal_argument
        EXPORTING
          name  = 'I_PADDING_STANDARD'
          value = 'Unsupported padding standard'.

    ENDIF.

  ENDMETHOD.                    "validate_padding_standard


  METHOD validate_raw16_table_size.
    DATA: lv_line_of_raw16_table  TYPE int4.

    lv_line_of_raw16_table = lines( it_data ).

    IF  i_data_length_in_byte > lv_line_of_raw16_table * mc_block_length_in_byte OR
        i_data_length_in_byte <= ( lv_line_of_raw16_table - 1 ) * mc_block_length_in_byte.

      RAISE EXCEPTION TYPE cx_me_illegal_argument
        EXPORTING
          name  = 'I_DATA_LENGTH_IN_BYTE'
          value = 'Data length and table size do not match.'.

    ENDIF.

  ENDMETHOD.                    "validate_raw16_table_size
ENDCLASS.
