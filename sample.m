typedef void (^SuccessHandler)(NSDictionary *response);

- (AAPLListItem *)itemWithName:(NSString * _Nullable)name;
- (AAPLListItem * _Nonnull)itemWithPrice:(NSNumber *)price;
- (NSInteger)indexOfItem:(AAPLListItem *)item;
- (void)getItems:(SuccessHandler)success
         failure:(void (^)(NSDictionary *dictionary, NSError *error)failure;

@property (copy, nullable) NSString *name;
@property (copy, readonly) NSArray<AAPLListItem *> *allItems;
