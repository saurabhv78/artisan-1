// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signin_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SignInPageState {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  List<int> get removedInd => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SignInPageStateCopyWith<SignInPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignInPageStateCopyWith<$Res> {
  factory $SignInPageStateCopyWith(
          SignInPageState value, $Res Function(SignInPageState) then) =
      _$SignInPageStateCopyWithImpl<$Res, SignInPageState>;
  @useResult
  $Res call({String email, String password, List<int> removedInd});
}

/// @nodoc
class _$SignInPageStateCopyWithImpl<$Res, $Val extends SignInPageState>
    implements $SignInPageStateCopyWith<$Res> {
  _$SignInPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? removedInd = null,
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
      removedInd: null == removedInd
          ? _value.removedInd
          : removedInd // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SignInPageStateImplCopyWith<$Res>
    implements $SignInPageStateCopyWith<$Res> {
  factory _$$SignInPageStateImplCopyWith(_$SignInPageStateImpl value,
          $Res Function(_$SignInPageStateImpl) then) =
      __$$SignInPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password, List<int> removedInd});
}

/// @nodoc
class __$$SignInPageStateImplCopyWithImpl<$Res>
    extends _$SignInPageStateCopyWithImpl<$Res, _$SignInPageStateImpl>
    implements _$$SignInPageStateImplCopyWith<$Res> {
  __$$SignInPageStateImplCopyWithImpl(
      _$SignInPageStateImpl _value, $Res Function(_$SignInPageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? removedInd = null,
  }) {
    return _then(_$SignInPageStateImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      removedInd: null == removedInd
          ? _value._removedInd
          : removedInd // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc

class _$SignInPageStateImpl implements _SignInPageState {
  const _$SignInPageStateImpl(
      {this.email = '',
      this.password = '',
      final List<int> removedInd = const []})
      : _removedInd = removedInd;

  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String password;
  final List<int> _removedInd;
  @override
  @JsonKey()
  List<int> get removedInd {
    if (_removedInd is EqualUnmodifiableListView) return _removedInd;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_removedInd);
  }

  @override
  String toString() {
    return 'SignInPageState(email: $email, password: $password, removedInd: $removedInd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignInPageStateImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            const DeepCollectionEquality()
                .equals(other._removedInd, _removedInd));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password,
      const DeepCollectionEquality().hash(_removedInd));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignInPageStateImplCopyWith<_$SignInPageStateImpl> get copyWith =>
      __$$SignInPageStateImplCopyWithImpl<_$SignInPageStateImpl>(
          this, _$identity);
}

abstract class _SignInPageState implements SignInPageState {
  const factory _SignInPageState(
      {final String email,
      final String password,
      final List<int> removedInd}) = _$SignInPageStateImpl;

  @override
  String get email;
  @override
  String get password;
  @override
  List<int> get removedInd;
  @override
  @JsonKey(ignore: true)
  _$$SignInPageStateImplCopyWith<_$SignInPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
