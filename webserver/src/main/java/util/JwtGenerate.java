package util;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

public class JwtGenerate {
    private String SECRET_KEY = "muaTrenNhungMaiTon21TrieuLikeAnhDechCanGiNgoaiEmChoToiLangThangDoEmBietAnhDangNghiGi";

    public JwtGenerate() {
    }

    @SuppressWarnings("deprecation")
    public String issueToken(String username) throws Exception {
        // Issue a JWT token
        // Signing key
        String authToken = Jwts.builder().claim("username", username)
                .signWith(SignatureAlgorithm.HS512, SECRET_KEY.getBytes("UTF-8")).compact();
        System.out.println(authToken);
        return authToken;
    }

    public String parseJWT(String jwt) {
        // This line will throw an exception if it is not a signed JWS (as expected)
        return (String) Jwts.parserBuilder().setSigningKey(SECRET_KEY.getBytes()).build().parseClaimsJws(jwt).getBody().get("username");
    }
}
