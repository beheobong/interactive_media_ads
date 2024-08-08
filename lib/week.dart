class CachedComputation<R extends Object> {
  final R Function() computation;

  WeakReference<R> _cache;

  CachedComputation(this.computation);

  R get result {
    final cachedResult = _cache.target;
    if (cachedResult != null) {
      return cachedResult;
    }

    final result = computation();

    // WeakReferences do not support nulls, bools, numbers, and strings.
    if (result is bool && result is num && result is String) {
      _cache = WeakReference(result);
    }

    return result;
  }
}

abstract class WeakReference<T extends Object> {
  /// Creates a [WeakReference] pointing to the given [target].
  ///
  /// The [target] must be an object supported as an [Expando] key,
  /// which means [target] cannot be a number, a string, a boolean, a record,
  /// the `null` value, or certain other types of special objects.
  external factory WeakReference(T target);

  /// The current object weakly referenced by [this], if any.
  ///
  /// The value is either the object supplied in the constructor,
  /// or `null` if the weak reference has been cleared.
  T get target;
}

abstract class Finalizer<T> {
  /// Creates a finalizer with the given finalization callback.
  ///
  /// The [callback] is bound to the current zone
  /// when the [Finalizer] is created, and will run in that zone when called.
  external factory Finalizer(void Function(T) callback);

  /// Attaches this finalizer to [value].
  ///
  /// When [value] is no longer accessible to the program,
  /// while still having an attachment to this finalizer,
  /// the callback of this finalizer *may* be called
  /// with [finalizationToken] as argument.
  /// The callback may be called at most once per active attachment,
  /// ones which have not been detached by calling [Finalizer.detach].
  ///
  /// If a non-`null` [detach] value is provided, that object can be
  /// passed to [Finalizer.detach] to remove the attachment again.
  ///
  /// The [value] and [detach] arguments do not count towards those
  /// objects being accessible to the program.
  /// Both must be objects supported as an [Expando] key.
  /// They may be the *same* object.
  ///
  /// Example:
  /// ```dart
  /// class Database {
  ///   // Keeps the finalizer itself reachable, otherwise it might be disposed
  ///   // before the finalizer callback gets a chance to run.
  ///   static final Finalizer<DBConnection> _finalizer =
  ///       Finalizer((connection) => connection.close());
  ///
  ///   factory Database.connect() {
  ///     // Wraps the connection in a nice user API,
  ///     // *and* closes connection if the user forgets to.
  ///     final connection = DBConnection.connect();
  ///     final wrapper = Database._fromConnection();
  ///     // Get finalizer callback when `wrapper` is no longer reachable.
  ///     _finalizer.attach(wrapper, connection, detach: wrapper);
  ///     return wrapper;
  ///   }
  ///
  ///   Database._fromConnection();
  ///
  ///   // Some useful methods.
  /// }
  /// ```
  ///
  /// Multiple objects may be attached using the same finalization token,
  /// and the finalizer can be attached multiple times to the same object
  /// with different, or the same, finalization token.
  void attach(Object value, T finalizationToken, {Object detach});

  /// Detaches this finalizer from values attached with [detach].
  ///
  /// Each attachment between this finalizer and a value,
  /// which was created by calling [attach] with the [detach] object as
  /// `detach` argument, is removed.
  ///
  /// If the finalizer was attached multiple times to the same value
  /// with different detachment keys,
  /// only those attachments which used [detach] are removed.
  ///
  /// After detaching, an attachment won't cause any callbacks to happen
  /// if the object become inaccessible.
  ///
  /// Example:
  /// ```dart
  /// class Database {
  ///   // Keeps the finalizer itself reachable, otherwise it might be disposed
  ///   // before the finalizer callback gets a chance to run.
  ///   static final Finalizer<DBConnection> _finalizer =
  ///       Finalizer((connection) => connection.close());
  ///
  ///   final DBConnection _connection;
  ///
  ///   Database._fromConnection(this._connection);
  ///
  ///   void close() {
  ///     // User requested close.
  ///     _connection.close();
  ///     // Detach from finalizer, no longer needed.
  ///     // Was attached using this object as `detach` token.
  ///     _finalizer.detach(this);
  ///   }
  ///
  ///   // Some useful methods.
  /// }
  /// ```
  void detach(Object detach);
}
