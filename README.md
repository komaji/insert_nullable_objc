# insert_nullable_objc

Nullability が指定されていないやつに `_Nullablity` を問答無用で挿入するやつ。

## 対象

- プロパティ
- typedef
- メソッド

## 使い方

```diff
-DIRECTORY_PATTERN = './path/to/dir/**/*'
+DIRECTORY_PATTERN = './**/*'
```

`DIRECTORY_PATTERN` を変更して実行する。

```sh
$ ./insert_nullable_objc.ruby

-------------------------------------------------------
./sample.m
-------------------------------------------------------
-typedef void (^SuccessHandler)(NSDictionary *response);
+typedef void (^SuccessHandler)(NSDictionary _Nullable *response);

-- (AAPLListItem *)itemWithName:(NSString * _Nullable)name;
+- (AAPLListItem _Nullable *)itemWithName:(NSString * _Nullable)name;

-- (AAPLListItem * _Nonnull)itemWithPrice:(NSNumber *)price;
+- (AAPLListItem * _Nonnull)itemWithPrice:(NSNumber _Nullable *)price;

-- (NSInteger)indexOfItem:(AAPLListItem *)item;
+- (NSInteger)indexOfItem:(AAPLListItem _Nullable *)item;

-         failure:(void (^)(NSDictionary *dictionary, NSError *error)failure;
+         failure:(void (^ _Nullable)(NSDictionary _Nullable *dictionary, NSError _Nullable *error)failure;

-@property (copy, readonly) NSArray<AAPLListItem *> *allItems;
+@property (copy, readonly) NSArray<AAPLListItem _Nullable *> _Nullable *allItems;


Finish!!!
```

## 注意

- `NS_ASSUME_NONNULL_BEGIN` が指定されていても挿入されてしまうので事前に個別に指定するように変更する
- 主に以下の二つを見て挿入しているので `id` とか `NSError **` とかは考慮されていない
  - ブロックかどうか
  - アスタリスクの有無
