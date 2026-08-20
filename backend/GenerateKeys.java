import java.io.File;
import java.io.FileOutputStream;
import java.nio.charset.StandardCharsets;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.util.Base64;

public class GenerateKeys {

    public static void main(String[] args) throws Exception {

        KeyPairGenerator kpg = KeyPairGenerator.getInstance("RSA");
        kpg.initialize(2048);

        KeyPair kp = kpg.generateKeyPair();

        String priv =
                "-----BEGIN PRIVATE KEY-----\n" +
                Base64.getMimeEncoder().encodeToString(
                        kp.getPrivate().getEncoded()
                ) +
                "\n-----END PRIVATE KEY-----\n";

        String pub =
                "-----BEGIN PUBLIC KEY-----\n" +
                Base64.getMimeEncoder().encodeToString(
                        kp.getPublic().getEncoded()
                ) +
                "\n-----END PUBLIC KEY-----\n";

        File certs = new File("certs");
        certs.mkdirs();

        try (FileOutputStream out =
                     new FileOutputStream("certs/private.pem")) {
            out.write(priv.getBytes(StandardCharsets.UTF_8));
        }

        try (FileOutputStream out =
                     new FileOutputStream("certs/public.pem")) {
            out.write(pub.getBytes(StandardCharsets.UTF_8));
        }

        System.out.println("Keys generated successfully!");
    }
}