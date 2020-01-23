class Fixnum
  def freq
    440 * (2**((self - 69) * 0.083333333333))
  end
  # method next tone
  # 1:1.05946
end
