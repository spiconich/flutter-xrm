abstract class GeneratePlanRemoteDataSource {
  Future<Map<String, dynamic>> initializeSession(Map<String, dynamic> authData);
  Future<Map<String, dynamic>> brokerLogin();
  Future<Map<String, dynamic>> getAllAuths();
}
