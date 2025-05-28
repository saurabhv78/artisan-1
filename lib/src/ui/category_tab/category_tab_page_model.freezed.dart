// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_tab_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CategoryTabPageState {
  bool get isRefreshing => throw _privateConstructorUsedError;
  int get refreshCounter => throw _privateConstructorUsedError;
  String get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CategoryTabPageStateCopyWith<CategoryTabPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryTabPageStateCopyWith<$Res> {
  factory $CategoryTabPageStateCopyWith(CategoryTabPageState value,
          $Res Function(CategoryTabPageState) then) =
      _$CategoryTabPageStateCopyWithImpl<$Res, CategoryTabPageState>;
  @useResult
  $Res call({bool isRefreshing, int refreshCounter, String errorMessage});
}

/// @nodoc
class _$CategoryTabPageStateCopyWithImpl<$Res,
        $Val extends CategoryTabPageState>
    implements $CategoryTabPageStateCopyWith<$Res> {
  _$CategoryTabPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRefreshing = null,
    Object? refreshCounter = null,
    Object? errorMessage = null,
  }) {
    return _then(_value.copyWith(
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      refreshCounter: null == refreshCounter
          ? _value.refreshCounter
          : refreshCounter // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryTabPageStateImplCopyWith<$Res>
    implements $CategoryTabPageStateCopyWith<$Res> {
  factory _$$CategoryTabPageStateImplCopyWith(_$CategoryTabPageStateImpl value,
          $Res Function(_$CategoryTabPageStateImpl) then) =
      __$$CategoryTabPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isRefreshing, int refreshCounter, String errorMessage});
}

/// @nodoc
class __$$CategoryTabPageStateImplCopyWithImpl<$Res>
    extends _$CategoryTabPageStateCopyWithImpl<$Res, _$CategoryTabPageStateImpl>
    implements _$$CategoryTabPageStateImplCopyWith<$Res> {
  __$$CategoryTabPageStateImplCopyWithImpl(_$CategoryTabPageStateImpl _value,
      $Res Function(_$CategoryTabPageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRefreshing = null,
    Object? refreshCounter = null,
    Object? errorMessage = null,
  }) {
    return _then(_$CategoryTabPageStateImpl(
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      refreshCounter: null == refreshCounter
          ? _value.refreshCounter
          : refreshCounter // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CategoryTabPageStateImpl implements _CategoryTabPageState {
  const _$CategoryTabPageStateImpl(
      {this.isRefreshing = false,
      this.refreshCounter = 0,
      this.errorMessage = ''});

  @override
  @JsonKey()
  final bool isRefreshing;
  @override
  @JsonKey()
  final int refreshCounter;
  @override
  @JsonKey()
  final String errorMessage;

  @override
  String toString() {
    return 'CategoryTabPageState(isRefreshing: $isRefreshing, refreshCounter: $refreshCounter, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryTabPageStateImpl &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.refreshCounter, refreshCounter) ||
                other.refreshCounter == refreshCounter) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isRefreshing, refreshCounter, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryTabPageStateImplCopyWith<_$CategoryTabPageStateImpl>
      get copyWith =>
          __$$CategoryTabPageStateImplCopyWithImpl<_$CategoryTabPageStateImpl>(
              this, _$identity);
}

abstract class _CategoryTabPageState implements CategoryTabPageState {
  const factory _CategoryTabPageState(
      {final bool isRefreshing,
      final int refreshCounter,
      final String errorMessage}) = _$CategoryTabPageStateImpl;

  @override
  bool get isRefreshing;
  @override
  int get refreshCounter;
  @override
  String get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$CategoryTabPageStateImplCopyWith<_$CategoryTabPageStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
