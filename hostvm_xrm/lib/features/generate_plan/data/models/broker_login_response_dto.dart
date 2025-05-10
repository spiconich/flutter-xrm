class BrokerLoginResponseDto {
  final String status;
  final String? result;

  BrokerLoginResponseDto({required this.result, required this.status});

  factory BrokerLoginResponseDto.fromJson(Map<String, dynamic> json) {
    return BrokerLoginResponseDto(
      result: json['result'],
      status: json['status'],
    );
  }
}
