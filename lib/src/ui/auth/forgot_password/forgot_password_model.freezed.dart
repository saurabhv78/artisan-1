// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forgot_password_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ForgotPasswordPageState {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get otp => throw _privateConstructorUsedError;
  String get confPass => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ForgotPasswordPageStateCopyWith<ForgotPasswordPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgotPasswordPageStateCopyWith<$Res> {
  factory $ForgotPasswordPageStateCopyWith(ForgotPasswordPageState value,
          $Res Function(ForgotPasswordPageState) then) =
      _$ForgotPasswordPageStateCopyWithImpl<$Res, ForgotPasswordPageState>;
  @useResult
  $Res call({String email, String password, String otp, String confPass});
}

/// @nodoc
class _$ForgotPasswordPageStateCopyWithImpl<$Res,
        $Val extends ForgotPasswordPageState>
    implements $ForgotPasswordPageStateCopyWith<$Res> {
  _$ForgotPasswordPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? otp = null,
    Object? confPass = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      confPass: null == confPass
          ? _value.confPass
          : confPass // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForgotPasswordPageStateImplCopyWith<$Res>
    implements $ForgotPasswordPageStateCopyWith<$Res> {
  factory _$$ForgotPasswordPageStateImplCopyWith(
          _$ForgotPasswordPageStateImpl value,
          $Res Function(_$ForgotPasswordPageStateImpl) then) =
      __$$ForgotPasswordPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password, String otp, String confPass});
}

/// @nodoc
class __$$ForgotPasswordPageStateImplCopyWithImpl<$Res>
    extends _$ForgotPasswordPageStateCopyWithImpl<$Res,
        _$ForgotPasswordPageStateImpl>
    implements _$$ForgotPasswordPageStateImplCopyWith<$Res> {
  __$$ForgotPasswordPageStateImplCopyWithImpl(
      _$ForgotPasswordPageStateImpl _value,
      $Res Function(_$ForgotPasswordPageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? otp = null,
    Object? confPass = null,
  }) {
    return _then(_$ForgotPasswordPageStateImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      confPass: null == confPass
          ? _value.confPass
          : confPass // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ForgotPasswordPageStateImpl implements _ForgotPasswordPageState {
  const _$ForgotPasswordPageStateImpl(
      {this.email = '', this.password = '', this.otp = '', this.confPass = ''});

  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String password;
  @override
  @JsonKey()
  final String otp;
  @override
  @JsonKey()
  final String confPass;

  @override
  String toString() {
    return 'ForgotPasswordPageState(email: $email, password: $password, otp: $otp, confPass: $confPass)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordPageStateImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.otp, otp) || other.otp == otp) &&
            (identical(other.confPass, confPass) ||
                other.confPass == confPass));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password, otp, confPass);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgotPasswordPageStateImplCopyWith<_$ForgotPasswordPageStateImpl>
      get copyWith => __$$ForgotPasswordPageStateImplCopyWithImpl<
          _$ForgotPasswordPageStateImpl>(this, _$identity);
}

abstract class _ForgotPasswordPageState implements ForgotPasswordPageState {
  const factory _ForgotPasswordPageState(
      {final String email,
      final String password,
      final String otp,
      final String confPass}) = _$ForgotPasswordPageStateImpl;

  @override
  String get email;
  @override
  String get password;
  @override
  String get otp;
  @override
  String get confPass;
  @override
  @JsonKey(ignore: true)
  _$$ForgotPasswordPageStateImplCopyWith<_$ForgotPasswordPageStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
