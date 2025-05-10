class BrokerLoginResponseDto {
  final String result;
  final String version;

  BrokerLoginResponseDto({required this.result, required this.version});

  factory BrokerLoginResponseDto.fromJson(Map<String, dynamic> json) {
    return BrokerLoginResponseDto(
      result: json['result'],
      version: json['version'],
    );
  }
}
