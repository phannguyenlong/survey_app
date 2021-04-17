package util;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

public class JwtGenerate {
    private String SECRET_KEY = "muaTrenNhungMaiTon21TrieuLikeAnhDechCanGiNgoaiEmChoToiLangThangDoEmBietAnhDangNghiGi";

    public JwtGenerate() {}

    @SuppressWarnings("deprecation")
    public String issueToken(String username) throws Exception {
        // Issue a JWT token
        // Signing key
        String authToken = Jwts.builder().claim("username: ", username)
                .signWith(SignatureAlgorithm.HS512, SECRET_KEY.getBytes("UTF-8")).compact();
        System.out.println(authToken);
        return authToken;
    }
}
