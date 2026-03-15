package ejb;

import javax.sql.DataSource;

import jakarta.annotation.Resource;
import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;


@Stateless
@LocalBean
public class UserBean {

	@Resource(name = "mysql")
	private DataSource dataSource;

}
