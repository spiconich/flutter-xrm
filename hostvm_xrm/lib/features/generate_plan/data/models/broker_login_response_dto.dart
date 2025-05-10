class BrokerLoginResponseDto {
  final String result;

  BrokerLoginResponseDto({required this.result});

  factory BrokerLoginResponseDto.fromJson(Map<String, dynamic> json) {
    return BrokerLoginResponseDto(result: json['status']);
  }
}
