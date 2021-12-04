class Room {
  final String name;
  final bool isLoading;
  final bool isSubmitted;
  final String token;
  final String identity;

  Room({
    this.name,
    this.isLoading = false,
    this.isSubmitted = false,
    this.token,
    this.identity,
  });

  Room copyWith({
    String name,
    bool isLoading,
    bool isSubmitted,
    String token,
    String identity,
  }) {
    return Room(
      name: name ?? this.name,
      token: token ?? this.token,
      identity: identity ?? this.identity,
      isLoading: isLoading ?? this.isLoading,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}

