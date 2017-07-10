meta:
  id: edid
  title: EDID (VESA Enhanced Extended Display Identification Data)
  xref:
    repo: https://github.com/kaitai-io/edid.ksy
  license: CC0-1.0
  endian: le
seq:
  - id: magic
    contents: [0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00]
  - id: mfg_bytes
    type: u2
  - id: product_code
    type: u2
    doc: Manufacturer product code
  - id: serial
    type: u4
    doc: Serial number
  - id: mfg_week
    type: u1
    doc: Week of manufacture. Week numbering is not consistent between manufacturers.
  - id: mfg_year_mod
    type: u1
    doc: Year of manufacture, less 1990. (1990–2245). If week=255, it is the model year instead.
  - id: edid_version_major
    type: u1
    doc: EDID version, usually 1 (for 1.3)
  - id: edid_version_minor
    type: u1
    doc: EDID revision, usually 3 (for 1.3)
  - id: input_flags
    type: u1
  - id: screen_size_h
    type: u1
    doc: Maximum horizontal image size, in centimetres (max 292 cm/115 in at 16:9 aspect ratio)
  - id: screen_size_v
    type: u1
    doc: Maximum vertical image size, in centimetres. If either byte is 0, undefined (e.g. projector)
  - id: gamma_mod
    type: u1
    doc: Display gamma, datavalue = (gamma*100)-100 (range 1.00–3.54)
  - id: features_flags
    type: u1
  - id: chromacity
    type: chromacity_info
    doc: 'Phosphor or filter chromaticity structure, which provides info on colorimetry and white point'
    doc-ref: Standard, section 3.7
types:
  chromacity_info:
    doc: |
      Chromaticity information: colorimetry and white point
      coordinates. All coordinates are stored as fixed precision
      10-bit numbers, bits are shuffled for compactness.
    seq:
      - id: red_x_1_0
        type: b2
        doc: Red X, bits 1..0
      - id: red_y_1_0
        type: b2
        doc: Red Y, bits 1..0
      - id: green_x_1_0
        type: b2
        doc: Green X, bits 1..0
      - id: green_y_1_0
        type: b2
        doc: Green Y, bits 1..0
      - id: blue_x_1_0
        type: b2
        doc: Blue X, bits 1..0
      - id: blue_y_1_0
        type: b2
        doc: Blue Y, bits 1..0
      - id: white_x_1_0
        type: b2
        doc: White X, bits 1..0
      - id: white_y_1_0
        type: b2
        doc: White Y, bits 1..0
      - id: red_x_9_2
        type: u1
        doc: Red X, bits 9..2
      - id: red_y_9_2
        type: u1
        doc: Red Y, bits 9..2
      - id: green_x_9_2
        type: u1
        doc: Green X, bits 9..2
      - id: green_y_9_2
        type: u1
        doc: Green Y, bits 9..2
      - id: blue_x_9_2
        type: u1
        doc: Blue X, bits 9..2
      - id: blue_y_9_2
        type: u1
        doc: Blue Y, bits 9..2
      - id: white_x_9_2
        type: u1
        doc: White X, bits 9..2
      - id: white_y_9_2
        type: u1
        doc: White Y, bits 9..2
    instances:
      # Raw chromacity coordinates as 10-bit integers
      red_x_int:
        value: '(red_x_9_2 << 2) | red_x_1_0'
      red_y_int:
        value: '(red_y_9_2 << 2) | red_y_1_0'
      green_x_int:
        value: '(green_x_9_2 << 2) | green_x_1_0'
      green_y_int:
        value: '(green_y_9_2 << 2) | green_y_1_0'
      blue_x_int:
        value: '(blue_x_9_2 << 2) | blue_x_1_0'
      blue_y_int:
        value: '(blue_y_9_2 << 2) | blue_y_1_0'
      white_x_int:
        value: '(white_x_9_2 << 2) | white_x_1_0'
      white_y_int:
        value: '(white_y_9_2 << 2) | white_y_1_0'
      # User-friendly chromacity coordinates as floating point fractions
      red_x:
        value: red_x_int / 1024.0
        doc: Red X coordinate
      red_y:
        value: red_y_int / 1024.0
        doc: Red Y coordinate
      green_x:
        value: green_x_int / 1024.0
        doc: Green X coordinate
      green_y:
        value: green_y_int / 1024.0
        doc: Green Y coordinate
      blue_x:
        value: blue_x_int / 1024.0
        doc: Blue X coordinate
      blue_y:
        value: blue_y_int / 1024.0
        doc: Blue Y coordinate
      white_x:
        value: white_x_int / 1024.0
        doc: White X coordinate
      white_y:
        value: white_y_int / 1024.0
        doc: White Y coordinate
instances:
  mfg_id_ch1:
    value: '(mfg_bytes & 0b0111110000000000) >> 10'
  mfg_id_ch2:
    value: '(mfg_bytes & 0b0000001111100000) >> 5'
  mfg_id_ch3:
    value: '(mfg_bytes & 0b0000000000011111)'
#  mfg_str:
#    value: '[mfg_id_ch1 + 0x40, mfg_id_ch2 + 0x40, mfg_id_ch3 + 0x40].to_s("ASCII")'
  mfg_year:
    value: mfg_year_mod + 1990
  gamma:
    value: (gamma_mod + 100) / 100.0
    if: gamma_mod != 0xff
