# insert_nullable_objc

Nullability が指定されていないやつに `_Nullablity` を問答無用で挿入するやつ。

## 対象

- プロパティ
- typedef
- メソッド

## 注意

- `NS_ASSUME_NONNULL_BEGIN` が指定されていても挿入されてしまうので事前に個別に指定するように変更する
- 主に以下の二つを見て挿入しているので `id` とか `NSError **` とかは考慮されていない
  - ブロックかどうか
  - アスタリスクの有無
