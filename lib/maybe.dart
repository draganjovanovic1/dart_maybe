/**
 * Extracts value from [maybe] if not nothing, else returns [defaultValue].
 */
T some<T>(Maybe<T> maybe, T defaultValue) {
  if (nothing(maybe)) {
    return defaultValue;
  }
  return maybe._value;
}

/**
 * Extracts value from [maybe] if not nothing, else returns [defaultValue].
 */
bool nothing<T>(Maybe<T> maybe) {
  if (maybe == null || maybe._isNothing) {
    return true;
  }
  return false;
}

/**
 * Tests the [maybe] status : executes [some] if it contains a value, [whenNothing] if not.
 * 
 * When adding [defaultValue], [isSome] is called with the value instead of [isNothing].
 */
void when<T>(Maybe<T> maybe,
    {MaybeNothing isNothing, MaybeSome<T> isSome, MaybeDefault<T> defaultValue}) {
  if (nothing(maybe)) {
    if (defaultValue != null) {
      if(isSome != null) {
        isSome(defaultValue());
      }
    } else if(isNothing != null) {
      isNothing();
    }
  } else if (isSome != null) {
    isSome(maybe._value);
  }
}

/**
 * The [Maybe] type encapsulates an optional value. A value of 
 * type [Maybe<T>] either contains a value of type [T] (built with
 * [Maybe<T>.just]), or it is empty (built with [Maybe<T>.nothing]). 
 */
class Maybe<T> {
  bool _isNothing;
  final T _value;

  /**
   * An empty value.
   */
  Maybe.nothing()
      : this._isNothing = true,
        this._value = null;

  /**
   * Some [value]. 
   * 
   * If [nullable], considered as [nothing] if [value] is null.
   * 
   * If [nothingWhen], considered as [nothing] when predicate is verified.
   */
  Maybe.some(this._value, {bool nullable = false, bool nothingWhen(T value)})
      : this._isNothing = (!nullable && _value == null) ||
            (nothingWhen != null && nothingWhen(_value));

  /**
   *  Flattens two nested [maybe] into one. 
   */
  static Maybe<T> flatten<T>(Maybe<Maybe<T>> maybe) {
    if (maybe == null || maybe._isNothing) {
      return Maybe.nothing();
    }

    return maybe._value;
  }

  /**
   * Returns a new lazy [Iterable] with all elements with a value in [maybeIterable].
   *
   * The matching elements have the same order in the returned iterable
   * as they have in [maybeIterable].
   */
  static Iterable<T> filter<T>(Iterable<Maybe<T>> maybeIterable) {
    return (maybeIterable == null)
        ? Iterable.empty<T>()
        : maybeIterable
            .where((v) => v != null && !v._isNothing)
            .map((v) => v._value);
  }

  /**
   * Applies the function [f] to each element with a value of [maybeIterable] collection 
   * in iteration order.
   */
  static void forEach<T>(Iterable<Maybe<T>> maybeIterable, void f(T element)) {
    if (maybeIterable == null) {
      maybeIterable
          .where((v) => v != null && !v._isNothing)
          .map((v) => v._value)
          .forEach(f);
    }
  }

  /**
   * Returns the number of elements with a value in [maybeIterable].
   */
  static int count<T>(Iterable<Maybe<T>> maybeList) {
    return (maybeList == null)
        ? 0
        : maybeList.where((v) => v != null && !v._isNothing).length;
  }
}

typedef void MaybeNothing();

typedef void MaybeSome<T>(T value);

typedef T MaybeDefault<T>();
