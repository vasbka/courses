import com.wix.mysql.EmbeddedMysql;
import com.wix.mysql.config.MysqldConfig;

import java.util.Scanner;

import static com.wix.mysql.EmbeddedMysql.anEmbeddedMysql;
import static com.wix.mysql.ScriptResolver.classPathScript;
import static com.wix.mysql.config.MysqldConfig.aMysqldConfig;
import static com.wix.mysql.distribution.Version.v5_7_latest;

public class App {
    public static void main(String[] args) {
        MysqldConfig config = aMysqldConfig(v5_7_latest)
                .withPort(1234)
                .withUser("user", "pwd")
                .build();



        EmbeddedMysql mysqld = anEmbeddedMysql(config)
                .addSchema("inno", classPathScript("db/innodb.sql"))
//                .addSchema("myisam", classPathScript("db/myisam.sql"))
//                .addSchema("deInno", classPathScript("db/deno_innodb.sql"))
//                .addSchema("deMyisam", classPathScript("db/deno_myisam.sql"))
                .start();

        new Scanner(System.in).nextLine();

        mysqld.stop();
    }
}
