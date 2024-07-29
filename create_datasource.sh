#Base to create a JNDI and Datasource using wsadmin 
cd /path/to/WebSphere/AppServer/bin

./wsadmin.sh -lang jython -user <username> -password <password>

cell = AdminControl.getCell()
server = AdminControl.completeObjectName('WebSphere:type=Server,*')
serverName = AdminControl.getAttribute(server, 'name')
nodeName = AdminControl.getAttribute(server, 'nodeName')

jdbcProvider = AdminConfig.create('JDBCProvider', AdminConfig.getid('/Cell:' + cell + '/'), 
   [['name', 'OracleJDBCProvider'], 
    ['implementationClassName', 'oracle.jdbc.pool.OracleConnectionPoolDataSource'], 
    ['description', 'Oracle JDBC Provider'], 
    ['providerType', 'Oracle JDBC Driver'], 
    ['classpath', '/path/to/ojdbc6.jar'], 
    ['nativePath', '']])

dataSource = AdminConfig.create('DataSource', jdbcProvider, 
   [['name', 'MyOracleDataSource'], 
    ['jndiName', 'jdbc/myOracleDataSource'], 
    ['description', 'My Oracle Data Source']])

AdminConfig.create('J2EEResourcePropertySet', dataSource, [])

AdminConfig.create('J2EEResourceProperty', dataSource + '/J2EEResourcePropertySet:/', 
   [['name', 'URL'], 
    ['type', 'java.lang.String'], 
    ['value', 'jdbc:oracle:thin:@myserver:1521:mydb']])

AdminConfig.create('J2EEResourceProperty', dataSource + '/J2EEResourcePropertySet:/', 
   [['name', 'user'], 
    ['type', 'java.lang.String'], 
    ['value', 'myuser']])

AdminConfig.create('J2EEResourceProperty', dataSource + '/J2EEResourcePropertySet:/', 
   [['name', 'password'], 
    ['type', 'java.lang.String'], 
    ['value', 'mypassword']])



AdminConfig.save()


AdminControl.testConnection('jdbc/myOracleDataSource')
