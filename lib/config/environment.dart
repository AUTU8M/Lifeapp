// enum Environment { aws, digitalOcean }

// class EnvironmentConfig {
//   static final EnvironmentConfig _instance = EnvironmentConfig._internal();
//   factory EnvironmentConfig() => _instance;
//   EnvironmentConfig._internal();

//   late Environment _environment;
//   late String _baseUrl;

 
//   void initializeConfig(Environment env) {
//     _environment = env;
//     switch (env) {
//       case Environment.aws:
//         _baseUrl = "https://api.gappubobo.com";  
//         break;
//       case Environment.digitalOcean:
//         _baseUrl = "https://api.life-lab.org";  
//         break;
//     }
//   }

//   // Getter for the base URL
//   String get baseUrl => _baseUrl;
  
//   // Getter for current environment
//   Environment get environment => _environment;
// }


