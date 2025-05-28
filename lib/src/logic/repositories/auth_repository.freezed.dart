// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthState {
  UserData? get authUser => throw _privateConstructorUsedError;
  String? get idToken => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  bool get checkbox => throw _privateConstructorUsedError;
  List<String> get wishlist => throw _privateConstructorUsedError;
  List<String> get cartData => throw _privateConstructorUsedError;
  AuthStatus get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
  @useResult
  $Res call(
      {UserData? authUser,
      String? idToken,
      String? email,
      String? password,
      bool checkbox,
      List<String> wishlist,
      List<String> cartData,
      AuthStatus status});
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authUser = freezed,
    Object? idToken = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? checkbox = null,
    Object? wishlist = null,
    Object? cartData = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      authUser: freezed == authUser
          ? _value.authUser
          : authUser // ignore: cast_nullable_to_non_nullable
              as UserData?,
      idToken: freezed == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      checkbox: null == checkbox
          ? _value.checkbox
          : checkbox // ignore: cast_nullable_to_non_nullable
              as bool,
      wishlist: null == wishlist
          ? _value.wishlist
          : wishlist // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cartData: null == cartData
          ? _value.cartData
          : cartData // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AuthStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthStateImplCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$AuthStateImplCopyWith(
          _$AuthStateImpl value, $Res Function(_$AuthStateImpl) then) =
      __$$AuthStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserData? authUser,
      String? idToken,
      String? email,
      String? password,
      bool checkbox,
      List<String> wishlist,
      List<String> cartData,
      AuthStatus status});
}

/// @nodoc
class __$$AuthStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateImpl>
    implements _$$AuthStateImplCopyWith<$Res> {
  __$$AuthStateImplCopyWithImpl(
      _$AuthStateImpl _value, $Res Function(_$AuthStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authUser = freezed,
    Object? idToken = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? checkbox = null,
    Object? wishlist = null,
    Object? cartData = null,
    Object? status = null,
  }) {
    return _then(_$AuthStateImpl(
      authUser: freezed == authUser
          ? _value.authUser
          : authUser // ignore: cast_nullable_to_non_nullable
              as UserData?,
      idToken: freezed == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      checkbox: null == checkbox
          ? _value.checkbox
          : checkbox // ignore: cast_nullable_to_non_nullable
              as bool,
      wishlist: null == wishlist
          ? _value._wishlist
          : wishlist // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cartData: null == cartData
          ? _value._cartData
          : cartData // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AuthStatus,
    ));
  }
}

/// @nodoc

class _$AuthStateImpl implements _AuthState {
  const _$AuthStateImpl(
      {this.authUser = null,
      this.idToken = null,
      this.email = null,
      this.password = null,
      this.checkbox = false,
      final List<String> wishlist = const [],
      final List<String> cartData = const [],
      this.status = AuthStatus.initial})
      : _wishlist = wishlist,
        _cartData = cartData;

  @override
  @JsonKey()
  final UserData? authUser;
  @override
  @JsonKey()
  final String? idToken;
  @override
  @JsonKey()
  final String? email;
  @override
  @JsonKey()
  final String? password;
  @override
  @JsonKey()
  final bool checkbox;
  final List<String> _wishlist;
  @override
  @JsonKey()
  List<String> get wishlist {
    if (_wishlist is EqualUnmodifiableListView) return _wishlist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_wishlist);
  }

  final List<String> _cartData;
  @override
  @JsonKey()
  List<String> get cartData {
    if (_cartData is EqualUnmodifiableListView) return _cartData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cartData);
  }

  @override
  @JsonKey()
  final AuthStatus status;

  @override
  String toString() {
    return 'AuthState(authUser: $authUser, idToken: $idToken, email: $email, password: $password, checkbox: $checkbox, wishlist: $wishlist, cartData: $cartData, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateImpl &&
            (identical(other.authUser, authUser) ||
                other.authUser == authUser) &&
            (identical(other.idToken, idToken) || other.idToken == idToken) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.checkbox, checkbox) ||
                other.checkbox == checkbox) &&
            const DeepCollectionEquality().equals(other._wishlist, _wishlist) &&
            const DeepCollectionEquality().equals(other._cartData, _cartData) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      authUser,
      idToken,
      email,
      password,
      checkbox,
      const DeepCollectionEquality().hash(_wishlist),
      const DeepCollectionEquality().hash(_cartData),
      status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      __$$AuthStateImplCopyWithImpl<_$AuthStateImpl>(this, _$identity);
}

abstract class _AuthState implements AuthState {
  const factory _AuthState(
      {final UserData? authUser,
      final String? idToken,
      final String? email,
      final String? password,
      final bool checkbox,
      final List<String> wishlist,
      final List<String> cartData,
      final AuthStatus status}) = _$AuthStateImpl;

  @override
  UserData? get authUser;
  @override
  String? get idToken;
  @override
  String? get email;
  @override
  String? get password;
  @override
  bool get checkbox;
  @override
  List<String> get wishlist;
  @override
  List<String> get cartData;
  @override
  AuthStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
