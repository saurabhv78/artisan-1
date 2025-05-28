// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_otp_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VerifyOtpPageState {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get otp => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VerifyOtpPageStateCopyWith<VerifyOtpPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyOtpPageStateCopyWith<$Res> {
  factory $VerifyOtpPageStateCopyWith(
          VerifyOtpPageState value, $Res Function(VerifyOtpPageState) then) =
      _$VerifyOtpPageStateCopyWithImpl<$Res, VerifyOtpPageState>;
  @useResult
  $Res call({String email, String password, String otp});
}

/// @nodoc
class _$VerifyOtpPageStateCopyWithImpl<$Res, $Val extends VerifyOtpPageState>
    implements $VerifyOtpPageStateCopyWith<$Res> {
  _$VerifyOtpPageStateCopyWithImpl(this._value, this._then);

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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerifyOtpPageStateImplCopyWith<$Res>
    implements $VerifyOtpPageStateCopyWith<$Res> {
  factory _$$VerifyOtpPageStateImplCopyWith(_$VerifyOtpPageStateImpl value,
          $Res Function(_$VerifyOtpPageStateImpl) then) =
      __$$VerifyOtpPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password, String otp});
}

/// @nodoc
class __$$VerifyOtpPageStateImplCopyWithImpl<$Res>
    extends _$VerifyOtpPageStateCopyWithImpl<$Res, _$VerifyOtpPageStateImpl>
    implements _$$VerifyOtpPageStateImplCopyWith<$Res> {
  __$$VerifyOtpPageStateImplCopyWithImpl(_$VerifyOtpPageStateImpl _value,
      $Res Function(_$VerifyOtpPageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? otp = null,
  }) {
    return _then(_$VerifyOtpPageStateImpl(
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
    ));
  }
}

/// @nodoc

class _$VerifyOtpPageStateImpl implements _VerifyOtpPageState {
  const _$VerifyOtpPageStateImpl(
      {this.email = '', this.password = '', this.otp = ''});

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
  String toString() {
    return 'VerifyOtpPageState(email: $email, password: $password, otp: $otp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyOtpPageStateImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.otp, otp) || other.otp == otp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password, otp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyOtpPageStateImplCopyWith<_$VerifyOtpPageStateImpl> get copyWith =>
      __$$VerifyOtpPageStateImplCopyWithImpl<_$VerifyOtpPageStateImpl>(
          this, _$identity);
}

abstract class _VerifyOtpPageState implements VerifyOtpPageState {
  const factory _VerifyOtpPageState(
      {final String email,
      final String password,
      final String otp}) = _$VerifyOtpPageStateImpl;

  @override
  String get email;
  @override
  String get password;
  @override
  String get otp;
  @override
  @JsonKey(ignore: true)
  _$$VerifyOtpPageStateImplCopyWith<_$VerifyOtpPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
