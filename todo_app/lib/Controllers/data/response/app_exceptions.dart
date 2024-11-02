




class AppExceptions implements Exception {
  final _message;
  final _prefix;
  AppExceptions([this._message, this._prefix]);

  @override
  String toString() {
    return ('$_prefix$_message');
  }
}

//if token is expired or not correct
class UnauthorizedException extends AppExceptions {
  UnauthorizedException([String? message])
      : super(message, 'Unauthorized Request');
}

// if time out for 10sec result not coming
class FetchDataException extends AppExceptions {
  FetchDataException([String? message])
      : super(message, 'Error During Comunication 500');
}