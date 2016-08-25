// Generated by Apple Swift version 2.2 (swiftlang-703.0.18.1 clang-703.0.29)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if defined(__has_feature) && __has_feature(modules)
@import Realm;
@import ObjectiveC;
@import Foundation;
@import Realm.Private;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class RLMRealm;
@class RLMObjectSchema;
@class RLMSchema;
@class RLMProperty;
@class RLMListBase;
@class RLMOptionalBase;
@class LinkingObjectsBase;


/// Object is a class used to define Realm model objects.
///
/// In Realm you define your model classes by subclassing <code>Object
/// </code> and adding properties to be managed.
/// You then instantiate and use your custom subclasses instead of using the <code>Object
/// </code> class directly.
///
/// <code>class Dog: Object {
///     dynamic var name: String = ""
///     dynamic var adopted: Bool = false
///     let siblings = List<Dog>()
/// }
/// 
/// </code>
/// <h3>Supported property types</h3>
/// <ul><li><code>String
/// </code>, <code>NSString
/// </code></li><li><code>Int
/// </code></li><li><code>Int8
/// </code>, <code>Int16
/// </code>, <code>Int32
/// </code>, <code>Int64
/// </code></li><li><code>Float
/// </code></li><li><code>Double
/// </code></li><li><code>Bool
/// </code></li><li><code>NSDate
/// </code></li><li><code>NSData
/// </code></li><li><code>RealmOptional<T>
/// </code> for optional numeric properties</li><li><code>Object
/// </code> subclasses, to model many-to-one relationships</li><li><code>List<T>
/// </code>, to model many-to-many relationships</li></ul>
/// <code>String
/// </code>, <code>NSString
/// </code>, <code>NSDate
/// </code>, <code>NSData
/// </code> and <code>Object
/// </code> subclass properties can be declared as optional. <code>Int
/// </code>, <code>Int8
/// </code>,
/// Int16<code>, Int32
/// </code>, <code>Int64
/// </code>, <code>Float
/// </code>, <code>Double
/// </code>, <code>Bool
/// </code>, and <code>List
/// </code> properties cannot. To store an optional number, use
/// <code>RealmOptional<Int>
/// </code>, <code>RealmOptional<Float>
/// </code>, <code>RealmOptional<Double>
/// </code>, or <code>RealmOptional<Bool>
/// </code> instead, which wraps an
/// optional numeric value.
///
/// All property types except for <code>List
/// </code> and <code>RealmOptional
/// </code> <em>must</em> be declared as <code>dynamic var
/// </code>. <code>List
/// </code> and
/// <code>RealmOptional
/// </code> properties must be declared as non-dynamic <code>let
/// </code> properties.
///
/// <h3>Querying</h3>
/// You can retrieve all objects of a given type from a Realm by calling the <code>objects(_:)
/// </code> instance method.
///
/// <h3>Relationships</h3>
/// See our <a href="http://realm.io/docs/cocoa">Cocoa guide</a> for more details.
SWIFT_CLASS_NAMED("Object")
@interface RealmSwiftObject : RLMObjectBase

/// Initializes an unmanaged instance of a Realm object.
///
/// Call <code>add(_:)
/// </code> on a <code>Realm
/// </code> instance to add an unmanaged object into that Realm.
///
/// <ul><li>see: <code>Realm().add(_:)
/// </code></li></ul>
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;

/// Initializes an unmanaged instance of a Realm object.
///
/// The <code>value
/// </code> argument is used to populate the object. It can be a key-value coding compliant object, an array or
/// dictionary returned from the methods in <code>NSJSONSerialization
/// </code>, or an <code>Array
/// </code> containing one element for each
/// managed property. An exception will be thrown if any required properties are not present and those properties were
/// not defined with default values.
///
/// When passing in an <code>Array
/// </code> as the <code>value
/// </code> argument, all properties must be present, valid and in the same order as
/// the properties defined in the model.
///
/// Call <code>add(_:)
/// </code> on a <code>Realm
/// </code> instance to add an unmanaged object into that Realm.
///
/// \param value The value used to populate the object.
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;

/// Indicates if the object can no longer be accessed because it is now invalid.
///
/// An object can no longer be accessed if the object has been deleted from the Realm that manages it, or if
/// <code>invalidate
/// </code> is called on that Realm.
@property (nonatomic, readonly, getter=isInvalidated) BOOL invalidated;

/// Returns a human-readable description of the object.
@property (nonatomic, readonly, copy) NSString * _Nonnull description;

/// A helper property that returns the class name for an Object subclass.
@property (nonatomic, readonly, copy) NSString * _Nonnull className;

/// WARNING: This is an internal helper method not intended for public use. :nodoc:
+ (Class _Nonnull)objectUtilClass:(BOOL)isSwift;

/// Override this method to specify the name of a property to be used as the primary key.
///
/// Only properties of types <code>String
/// </code> and <code>Int
/// </code> can be designated as the primary key. Primary key properties enforce
/// uniqueness for each value whenever the property is set, which incurs minor overhead. Indexes are created
/// automatically for primary key properties.
///
/// \returns  The name of the property designated as the primary key, or <code>nil
/// </code> if the model has no primary key.
+ (NSString * _Nullable)primaryKey;

/// Override this method to specify the names of properties to ignore. These properties will not be managed by the Realm that manages the object.
///
/// \returns  An array of property names to ignore.
+ (NSArray<NSString *> * _Nonnull)ignoredProperties;

/// Returns an array of property names for properties which should be indexed.
///
/// Only string, integer, boolean, and <code>NSDate
/// </code> properties are supported.
///
/// \returns  An array of property names.
+ (NSArray<NSString *> * _Nonnull)indexedProperties;
- (id _Nullable)objectForKeyedSubscript:(NSString * _Nonnull)key;
- (void)setObject:(id _Nullable)value forKeyedSubscript:(NSString * _Nonnull)key;

/// Returns whether two Realm objects are equal.
///
/// Objects are considered equal if and only if they are both managed by the same Realm and point to the same
/// underlying object in the database.
///
/// \param object The object to compare the receiver to.
- (BOOL)isEqual:(id _Nullable)object;

/// WARNING: This is an internal initializer not intended for public use. :nodoc:
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;

/// WARNING: This is an internal initializer not intended for public use. :nodoc:
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (RLMListBase * _Nonnull)listForProperty:(RLMProperty * _Nonnull)prop;
- (RLMOptionalBase * _Nonnull)optionalForProperty:(RLMProperty * _Nonnull)prop;
- (LinkingObjectsBase * _Nullable)linkingObjectsForProperty:(RLMProperty * _Nonnull)prop;
@end



/// Object interface which allows untyped getters and setters for Objects. :nodoc:
SWIFT_CLASS("_TtC10RealmSwift13DynamicObject")
@interface DynamicObject : RealmSwiftObject
- (RLMListBase * _Nonnull)listForProperty:(RLMProperty * _Nonnull)prop;
- (RLMOptionalBase * _Nonnull)optionalForProperty:(RLMProperty * _Nonnull)prop;
- (LinkingObjectsBase * _Nullable)linkingObjectsForProperty:(RLMProperty * _Nonnull)prop;

/// :nodoc:
- (id _Nullable)valueForUndefinedKey:(NSString * _Nonnull)key;

/// :nodoc:
- (void)setValue:(id _Nullable)value forUndefinedKey:(NSString * _Nonnull)key;

/// :nodoc:
+ (BOOL)shouldIncludeInDefaultSchema;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end

@class RLMResults;


/// :nodoc: Internal class. Do not use directly. Used for reflection and initialization
SWIFT_CLASS("_TtC10RealmSwift18LinkingObjectsBase")
@interface LinkingObjectsBase : NSObject <NSFastEnumeration>
@property (nonatomic, readonly, copy) NSString * _Nonnull objectClassName;
@property (nonatomic, readonly, copy) NSString * _Nonnull propertyName;
- (void)attachToObject:(RLMObjectBase * _Nonnull)object property:(RLMProperty * _Nonnull)property;
@property (nonatomic, readonly, strong) RLMResults * _Nonnull rlmResults;
- (nonnull instancetype)initFromClassName:(NSString * _Nonnull)objectClassName property:(NSString * _Nonnull)propertyName OBJC_DESIGNATED_INITIALIZER;
- (NSInteger)countByEnumeratingWithState:(NSFastEnumerationState * _Null_unspecified)state objects:(id _Nullable * _Null_unspecified)buffer count:(NSInteger)len;
@end

@class RLMArray;


/// :nodoc: Internal class. Do not use directly.
SWIFT_CLASS("_TtC10RealmSwift8ListBase")
@interface ListBase : RLMListBase

/// Returns a human-readable description of the objects contained in the List.
@property (nonatomic, readonly, copy) NSString * _Nonnull description;

/// Returns the number of objects in this List.
@property (nonatomic, readonly) NSInteger count;
- (null_unspecified instancetype)initWithArray:(RLMArray * _Null_unspecified)array OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface NSDate (SWIFT_EXTENSION(RealmSwift))
@end




/// :nodoc: Internal class. Do not use directly.
SWIFT_CLASS_NAMED("ObjectUtil")
@interface RealmSwiftObjectUtil : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end



/// :nodoc: Internal class. Do not use directly.
SWIFT_CLASS("_TtC10RealmSwift11ResultsBase")
@interface ResultsBase : NSObject <NSFastEnumeration>
@property (nonatomic, readonly, strong) RLMResults * _Nonnull rlmResults;

/// Returns a human-readable description of the objects contained in these results.
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
- (nonnull instancetype)init:(RLMResults * _Nonnull)rlmResults OBJC_DESIGNATED_INITIALIZER;
- (NSInteger)countByEnumeratingWithState:(NSFastEnumerationState * _Null_unspecified)state objects:(id _Nullable * _Null_unspecified)buffer count:(NSInteger)len;
@end

#pragma clang diagnostic pop