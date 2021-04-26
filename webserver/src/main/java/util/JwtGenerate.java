package util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

public class JwtGenerate {
    private String SECRET_KEY = "muaTrenNhungMaiTon21TrieuLikeAnhDechCanGiNgoaiEmChoToiLangThangDoEmBietAnhDangNghiGi";

    public JwtGenerate() {
    }

    @SuppressWarnings("deprecation")
    public String issueToken(String username, String role) throws Exception {
        // Issue a JWT token
        // Signing key
        String authToken = Jwts.builder().claim("username", username).claim("role", role)
                .signWith(SignatureAlgorithm.HS512, SECRET_KEY.getBytes("UTF-8")).compact();
        System.out.println(authToken);
        return authToken;
    }

    public String[] parseJWT(String jwt) {
        // This line will throw an exception if it is not a signed JWS (as expected)
        Claims claims = Jwts.parserBuilder().setSigningKey(SECRET_KEY.getBytes()).build().parseClaimsJws(jwt).getBody();
        String[] arr = { (String) claims.get("username"), (String) claims.get("role") };
        return arr;
        // return (String) Jwts.parserBuilder().setSigningKey(SECRET_KEY.getBytes()).build().parseClaimsJws(jwt).getBody().get("username");
    }
}
