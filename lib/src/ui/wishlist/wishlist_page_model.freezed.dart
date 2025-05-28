// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WishlistPageState {
  List<WishlistProductData> get wishlist => throw _privateConstructorUsedError;
  String get errMessage => throw _privateConstructorUsedError;
  WishlistPageStatus get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WishlistPageStateCopyWith<WishlistPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishlistPageStateCopyWith<$Res> {
  factory $WishlistPageStateCopyWith(
          WishlistPageState value, $Res Function(WishlistPageState) then) =
      _$WishlistPageStateCopyWithImpl<$Res, WishlistPageState>;
  @useResult
  $Res call(
      {List<WishlistProductData> wishlist,
      String errMessage,
      WishlistPageStatus status});
}

/// @nodoc
class _$WishlistPageStateCopyWithImpl<$Res, $Val extends WishlistPageState>
    implements $WishlistPageStateCopyWith<$Res> {
  _$WishlistPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wishlist = null,
    Object? errMessage = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      wishlist: null == wishlist
          ? _value.wishlist
          : wishlist // ignore: cast_nullable_to_non_nullable
              as List<WishlistProductData>,
      errMessage: null == errMessage
          ? _value.errMessage
          : errMessage // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as WishlistPageStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WishlistPageStateImplCopyWith<$Res>
    implements $WishlistPageStateCopyWith<$Res> {
  factory _$$WishlistPageStateImplCopyWith(_$WishlistPageStateImpl value,
          $Res Function(_$WishlistPageStateImpl) then) =
      __$$WishlistPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<WishlistProductData> wishlist,
      String errMessage,
      WishlistPageStatus status});
}

/// @nodoc
class __$$WishlistPageStateImplCopyWithImpl<$Res>
    extends _$WishlistPageStateCopyWithImpl<$Res, _$WishlistPageStateImpl>
    implements _$$WishlistPageStateImplCopyWith<$Res> {
  __$$WishlistPageStateImplCopyWithImpl(_$WishlistPageStateImpl _value,
      $Res Function(_$WishlistPageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wishlist = null,
    Object? errMessage = null,
    Object? status = null,
  }) {
    return _then(_$WishlistPageStateImpl(
      wishlist: null == wishlist
          ? _value._wishlist
          : wishlist // ignore: cast_nullable_to_non_nullable
              as List<WishlistProductData>,
      errMessage: null == errMessage
          ? _value.errMessage
          : errMessage // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as WishlistPageStatus,
    ));
  }
}

/// @nodoc

class _$WishlistPageStateImpl implements _WishlistPageState {
  const _$WishlistPageStateImpl(
      {final List<WishlistProductData> wishlist = const [],
      this.errMessage = '',
      this.status = WishlistPageStatus.initial})
      : _wishlist = wishlist;

  final List<WishlistProductData> _wishlist;
  @override
  @JsonKey()
  List<WishlistProductData> get wishlist {
    if (_wishlist is EqualUnmodifiableListView) return _wishlist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_wishlist);
  }

  @override
  @JsonKey()
  final String errMessage;
  @override
  @JsonKey()
  final WishlistPageStatus status;

  @override
  String toString() {
    return 'WishlistPageState(wishlist: $wishlist, errMessage: $errMessage, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishlistPageStateImpl &&
            const DeepCollectionEquality().equals(other._wishlist, _wishlist) &&
            (identical(other.errMessage, errMessage) ||
                other.errMessage == errMessage) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_wishlist), errMessage, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WishlistPageStateImplCopyWith<_$WishlistPageStateImpl> get copyWith =>
      __$$WishlistPageStateImplCopyWithImpl<_$WishlistPageStateImpl>(
          this, _$identity);
}

abstract class _WishlistPageState implements WishlistPageState {
  const factory _WishlistPageState(
      {final List<WishlistProductData> wishlist,
      final String errMessage,
      final WishlistPageStatus status}) = _$WishlistPageStateImpl;

  @override
  List<WishlistProductData> get wishlist;
  @override
  String get errMessage;
  @override
  WishlistPageStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$WishlistPageStateImplCopyWith<_$WishlistPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
