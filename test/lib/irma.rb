require 'test_helper'
require 'digest'
require 'base64'

class IrmaTest < ActionView::TestCase
  include Irma

  test 'signature test (RS256)' do
    key = <<~END_OF_KEY
      -----BEGIN RSA PRIVATE KEY-----
      MIIEpQIBAAKCAQEA19I/wHqplFBk5Dr8+T04er462JCWTO6gaG2xm5SPPKfJ8/o1
      Ia2sxLAafi8hVJc50qk3oFmouqYKwTk/V9/JtjtgL5gYWunDP1fd72XUZZf1+EYv
      iytgFns3zbgGiqPBHIZCnzSlJTbRqjspJTLBYbFhvx6rdSlQxj5gkAZwo70ZSXAz
      Zn+Uym90yp+vn013lPTM5wx6d0bTprsmQsyRBQfHNs0AyA04wfSJ46HS7QfcOuBw
      DgW4j7vwcn8hnCSIirEmL8PsXF+ivG7T9OO1J39JY21NJzeQx3/bu0gFlhDf0zXP
      F1tyBAekbvJEN1SdQlwl6R02YR/Xq2wnK+bLUwIDAQABAoIBAQCfLtIa095UKF/h
      /qgr5T3NOpYIucxB/heOLqo7SH3FjTRloXyi1IiDoihIPdbln4zkli8TNE5BLMrt
      7Z2M4ODUakLtl88O7zA1fkeRlZftPwILFylmCp4attNYBo28oD+FHHnzF09ffWlz
      l6MnbqI3vi+MWcC477pGHif20uktuqaMKm19FZpIM1exuN3XpAv5YJWDI7Kqlym9
      JtkNBiByeS2ZF0cPA2CVEPhDM1+dQRC99R8xBT2v/tXtYf0fCxeDGdUhUpfRdwlW
      YIt/sfQ1mvcIT+aWhXvC3yoLdurpU8KRM1xJIJPT5b35zgk7jwgp1/NsN2ZnW7SO
      gUQ4AQmhAoGBAPombY9luqQ7wSnAJWG9Kwaaj6uuMVZWK86Dy/uzQx5LfoUra1RT
      rK8FqCq+0yC1tLfzMG7NcmtIisZXe5KAgFqlzympHH74u5D1OlBsZOCMPiKYU5wb
      Ebl/Frk4K+ytbnmqgxvqTEQLbiC2uOUoV3cCZ0xjj5cCCwAtRf6BBOa7AoGBANze
      Tg7efM+bProwRyWT6aCf1G04w87MSPo0Khl58aqa+uD84FfzDlsxC+7Ye5jS1Ye+
      rf81DIZEfQESFdEtCErtCskwzoGLr13wNSvRovtVXJpTNCKfxO64o7RENXlTv5+H
      /BsSNuJcwAR1Su1wf4df5BYYz4CDPgDHkwU68wBJAoGAVXf7xxsDAkpIXXOBUjvI
      D6GPpSEHSnB210DA2WcOb7NrryR+r3lHbyWHp9M7X9m1vYQh8DnR9kX65HnPhubQ
      9Cfi+GEHk3p427ZuDjx62x4PvNI+/v9gtvhtUyuWFm/LZ1aTJV6QYE9neVX1Jpb6
      C3eOw9LgpL/V8mGFoMeEXTECgYEA1/0Jhp7qnTcrA3bczJG2AV7rpJfDXEMIBq3m
      kZ1fyD/goQ6J8Vf+LQ1spvjK/WsIZ8P/cbgV9GObfuWJslIAbw0Z5B+3gpXwO8QA
      q0ZJxND4Su6c6FMniW/Eny+ov2o31TFtR6frRjf/ixyM1l+SRvduHHHM0dcGVkrU
      qmO4aQkCgYEAlfcOmIRgDAorzjX6It2H9sTdV+bktx82d3F7zo/yT/YBjBCi8bOy
      CULz3kM+DWXFLu2Bl4LPkge2xXJ9no/6A6gLqpvh5uSk53Mi8+lrJHebFEjsb5jK
      rgRORzM1nANAhvy3FucxKiNSqPA8GcO8eroHYqaB0P3etsvtUazG7LM=
      -----END RSA PRIVATE KEY-----
      END_OF_KEY
    assert_equal(Irma.sign(:RS256, key,
         "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.e30"),
      Base64::urlsafe_decode64("qG-5yOO4sMvaRzkMEPwknRL5FuzqDohAnjGXbsOg4ZYG5dJSD-dhK52xAjdSy5qffoIe7Ndewg3mn_PkG34FhVIOlSKafSqEweH2O84Gg_sYNgZfdIkXwAFB9ZUlDwE99PEEealDjMrCSF2iqaV-qrF6yggk2jhWLh64vOgs8x0bkjBQP9WVALgA12-zVb_zxWAAlzhR78LOIypu12RPB6P0_7UPzwqm4pv_yzipCsRoPCOjAs1SgkMBg7WJjEw86YZPtimGyLc9mm97keg6adWxL-pTEKdTvPT--n6Ggeya-Srw3ONFWTdByIxcoMDRKQtQOvUVizvvBjFhDM0ELQ"))
  end

  test 'JWT open test (RS256)' do
    key = <<~END_RSA_KEY
      -----BEGIN PUBLIC KEY-----
      MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA19I/wHqplFBk5Dr8+T04
      er462JCWTO6gaG2xm5SPPKfJ8/o1Ia2sxLAafi8hVJc50qk3oFmouqYKwTk/V9/J
      tjtgL5gYWunDP1fd72XUZZf1+EYviytgFns3zbgGiqPBHIZCnzSlJTbRqjspJTLB
      YbFhvx6rdSlQxj5gkAZwo70ZSXAzZn+Uym90yp+vn013lPTM5wx6d0bTprsmQsyR
      BQfHNs0AyA04wfSJ46HS7QfcOuBwDgW4j7vwcn8hnCSIirEmL8PsXF+ivG7T9OO1
      J39JY21NJzeQx3/bu0gFlhDf0zXPF1tyBAekbvJEN1SdQlwl6R02YR/Xq2wnK+bL
      UwIDAQAB
      -----END PUBLIC KEY-----
      END_RSA_KEY

    assert_equal(JWT.Open("eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MjI3OTg2MDgsImlhdCI6MTYyMjc5ODQ4OCwiaXNzIjoiaXJtYXNlcnZlciIsInN1YiI6ImRpc2Nsb3NpbmdfcmVzdWx0IiwidG9rZW4iOiJSd0JpUGxkSXJKcldnWmhkUWEzUiIsInN0YXR1cyI6IkRPTkUiLCJ0eXBlIjoiZGlzY2xvc2luZyIsInByb29mU3RhdHVzIjoiVkFMSUQiLCJkaXNjbG9zZWQiOltbeyJyYXd2YWx1ZSI6ImJyYW1Ad2VzdGVyYmFhbi5uYW1lIiwidmFsdWUiOnsiIjoiYnJhbUB3ZXN0ZXJiYWFuLm5hbWUiLCJlbiI6ImJyYW1Ad2VzdGVyYmFhbi5uYW1lIiwibmwiOiJicmFtQHdlc3RlcmJhYW4ubmFtZSJ9LCJpZCI6InBiZGYuc2lkbi1wYmRmLmVtYWlsLmVtYWlsIiwic3RhdHVzIjoiUFJFU0VOVCIsImlzc3VhbmNldGltZSI6MTYyMDI1OTIwMH1dXX0.ynAlo9i9Uq9T-FRmlx3ctuS1jXhOqkAr34IlWck1WLDgpOX2PgvaJO04C2mfJUSpX9gG-IZyjSdF5Ni2pSDicOsExb7IwuEMAnAIjPTdi1ItLjLjxRDbovMlPfFhGpAsmBzkGBq4mN--d5Qyn0pTURn-2emFij5JfrExZQLbtaYOA4TLB3EF4Ck_-o3Lg6HAZa3cWnIdMC6NmJX0XfsGinMg8Slg7ShD8ChW2zEDaSksyVOzbi3juVuuXkZ4SgMvZHlVXygjreEcbhV1uRk82zgw5CDzisVgAxb2BzgxwQlEor7mGyS2lsff80Qt-Pf1uUuEmbqwIdHpNYGTp85FSQ", key).blank?, false) 

  end

  test 'signature test (HS256)' do
    # test vectors generated with the following python3 code:
    #
    # import hmac
    # import hashlib
    #
    # def hs256(m,k):
    #     return hmac.new(msg=m, key=k, digestmod=hashlib.sha256).digest()

    assert_equal(Digest.hexencode(Irma.hs256(
       "key", "The quick brown fox jumps over the lazy dog")), 
       "f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8")

    assert_equal(Digest.hexencode(Irma.hs256(
       "k"*64,"The quick brown fox jumps over the lazy dog")), 
       "bbbf90167fe46c7a3fa5b549325ad6428715eae339737730860fcea2c3f43d5c")

    assert_equal(Digest.hexencode(Irma.hs256(
        "k"*65, "The quick brown fox jumps over the lazy dog")), 
       "63f1ed5027bf6810091903c27a414315327d40360d0e4c3086c4b303c19efd60")
  end


end
