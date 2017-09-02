module Base32
  BASE32_TBL = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'

  def self.encode(s, padding = true)
    s_bin = s.bytes
    pad_chr_num = 5 - s_bin.length % 5
    if 0 < pad_chr_num && pad_chr_num < 5
      pad_chr_num.times { s_bin << 0 }
    end

    base32 = ''
    0.step(s_bin.length - 1, 5) do |i|
      base32 << BASE32_TBL[(s_bin[i] & 0xf8) >> 3]
      base32 << BASE32_TBL[(s_bin[i] & 0x7) << 2 | (s_bin[i+1] & 0xc0) >> 6]
      base32 << BASE32_TBL[(s_bin[i+1] & 0x3e) >> 1]
      base32 << BASE32_TBL[(s_bin[i+1] & 0x1) << 4 | (s_bin[i+2] & 0xf0) >> 4]
      base32 << BASE32_TBL[(s_bin[i+2] & 0xf) << 1 | (s_bin[i+3] & 0x80) >> 7]
      base32 << BASE32_TBL[(s_bin[i+3] & 0x7c) >> 2]
      base32 << BASE32_TBL[(s_bin[i+3] & 0x3) << 3 | (s_bin[i+4] & 0xe0) >> 5]
      base32 << BASE32_TBL[s_bin[i+4] & 0x1f]
    end

    if 0 < pad_chr_num && pad_chr_num < 5
      n = ((8 * pad_chr_num) / 5).floor
      base32 = base32.slice(0, base32.length - n)
      base32 += '=' * n if padding
    end

    base32
  end

  BASE32_DECODE_TBL = {
    'A' => 0,  'B' => 1,  'C' => 2,  'D' => 3,  'E' => 4,  'F' => 5,  'G' => 6,  'H' => 7,
    'I' => 8,  'J' => 9,  'K' => 10, 'L' => 11, 'M' => 12, 'N' => 13, 'O' => 14, 'P' => 15,
    'Q' => 16, 'R' => 17, 'S' => 18, 'T' => 19, 'U' => 20, 'V' => 21, 'W' => 22, 'X' => 23,
    'Y' => 24, 'Z' => 25, '2' => 26, '3' => 27, '4' => 28, '5' => 29, '6' => 30, '7' => 31
  }

  def self.decode(s)
    pad_chr_num = 0
    keys = []
    s += '=' * (s.bytesize % 8 == 0 ? 0 : 8 - s.bytesize % 8)
    s.bytesize.times do |i|
      if s[i] == '='
        pad_chr_num += 1
        keys << 0
      else
        keys << BASE32_DECODE_TBL[s[i]]
      end
    end

    bin = []
    0.step(keys.length - 1, 8) do |i|
      bin << (keys[i] << 3 | (keys[i+1] & 0x1c) >> 2)
      bin << ((keys[i+1] & 0x3) << 6 | keys[i+2] << 1 | (keys[i+3] & 0x10) >> 4)
      bin << ((keys[i+3] & 0xf) << 4 | (keys[i+4] & 0x1e) >> 1)
      bin << ((keys[i+4] & 0x1) << 7 | keys[i+5] << 2 | (keys[i+6] & 0x18) >> 3)
      bin << ((keys[i+6] & 0x7) << 5 | keys[i+7])
    end

    if pad_chr_num > 0
      n = ((5 * pad_chr_num) / 8).floor + 1
      bin = bin.slice(0, bin.length - n)
    end
    bin.pack('C*')
  end
end
