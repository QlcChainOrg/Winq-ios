// Generated by Apple Swift version 5.2.4 effective-4.1.50 (swiftlang-1103.0.32.9 clang-1103.0.32.53)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
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
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(ns_consumed)
# define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
# define SWIFT_RELEASES_ARGUMENT
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
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
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
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
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import Foundation;
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="QLCFramework",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif


SWIFT_CLASS("_TtC12QLCFramework7DPKIRpc")
@interface DPKIRpc : NSObject
+ (void)getAllVerifiersWithBaseUrl:(NSString * _Nonnull)baseUrl successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
+ (void)getPublishBlockWithBaseUrl:(NSString * _Nonnull)baseUrl params:(NSDictionary<NSString *, id> * _Nonnull)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
+ (void)getPubKeyByTypeAndIDWithBaseUrl:(NSString * _Nonnull)baseUrl type:(NSString * _Nonnull)type ID:(NSString * _Nonnull)ID successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
+ (void)getUnPublishBlockWithBaseUrl:(NSString * _Nonnull)baseUrl params:(NSDictionary<NSString *, id> * _Nonnull)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
+ (void)processWithBaseUrl:(NSString * _Nonnull)baseUrl dic:(NSDictionary<NSString *, id> * _Nonnull)dic successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
+ (void)getActiveVerifiersWithBaseUrl:(NSString * _Nonnull)baseUrl type:(NSString * _Nonnull)type successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
+ (void)getRecommendPubKeyWithBaseUrl:(NSString * _Nonnull)baseUrl type:(NSString * _Nonnull)type ID:(NSString * _Nonnull)ID successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
+ (void)getVerifiersByTypeWithBaseUrl:(NSString * _Nonnull)baseUrl type:(NSString * _Nonnull)type successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
+ (void)getAccountPublicKeyWithBaseUrl:(NSString * _Nonnull)baseUrl address:(NSString * _Nonnull)address successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end












SWIFT_CLASS("_TtC12QLCFramework12QLCLedgerRpc")
@interface QLCLedgerRpc : NSObject
/// Return number of blocks for a specific account
/// @param url
/// @param params string : the account address
/// @return
/// @throws QlcException
/// @throws IOException
+ (void)accountBlocksCountWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return blocks for the account, include each token of the account and order of blocks is forward from the last one
/// @param url
/// @param params string : the account address, int: number of blocks to return, int: optional , offset, index of block where to start, default is 0
/// @return
/// @throws QlcException
/// @throws IOException
+ (void)accountHistoryTopnWithAddress:(NSString * _Nonnull)address baseUrl:(NSString * _Nonnull)baseUrl successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return account detail info, include each token in the account
/// @param url
/// @param params string : the account address
/// @return
/// @throws QlcException
/// @throws IOException
+ (void)accountInfoWithAddress:(NSString * _Nonnull)address baseUrl:(NSString * _Nonnull)baseUrl successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return the representative address for account
/// @param url
/// @param params string : the account address
/// @return
/// @throws QlcException
/// @throws IOException
+ (void)accountRepresentativeWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return the vote weight for account
/// @param url
/// @param params string :  the vote weight for the account (if account not found, return error)
/// @return
/// @throws QlcException
/// @throws IOException
+ (void)accountVotingWeightWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return account list of chain
/// @param url
/// @param params int: number of accounts to return
/// int: optional , offset, index of account where to start, default is 0
/// @return []address: addresses list of accounts
/// @throws QlcException
/// @throws IOException
+ (void)accountsWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Returns balance and pending (amount that has not yet been received) for each account
/// @param url
/// @param params []string: addresses list
/// @return balance and pending amount of each token for each account
/// @throws QlcException
/// @throws IOException
+ (void)accountsBalanceWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return pairs of token name and block hash (representing the head block ) of each token for each account
/// @param url
/// @param params []string: addresses list
/// @return token name and block hash for each account
/// @throws QlcException
/// @throws IOException
+ (void)accountsFrontiersWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
+ (void)accountsPendingWithAddressArr:(NSArray<NSString *> * _Nonnull)addressArr baseUrl:(NSString * _Nonnull)baseUrl successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return total number of accounts of chain
/// @param url
/// @param params
/// @return: total number of accounts
/// @throws QlcException
/// @throws IOException
+ (void)accountsCountWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return the account that the block belong to
/// @param url
/// @param params string: block hash
/// @return: string: the account address (if block not found, return error)
/// @throws QlcException
/// @throws IOException
+ (void)blockAccountWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return hash for the block
/// @param url
/// @param params block: block info
/// @return: string: block hash
/// @throws QlcException
/// @throws IOException
+ (void)blockHashWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return blocks list of chain
/// @param url
/// @param params int: number of blocks to return
/// int: optional, offset, index of block where to start, default is 0
/// @return: []block: blocks list
/// @throws QlcException
/// @throws IOException
+ (void)blocksWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return the number of blocks (include smartcontrant block) and unchecked blocks of chain
/// @param url
/// @param params int: number of blocks to return
/// int: optional, offset, index of block where to start, default is 0
/// @return: number of blocks, means:
/// count: int, number of blocks , include smartcontrant block
/// unchecked: int, number of unchecked blocks
/// @throws QlcException
/// @throws IOException
+ (void)blocksCountWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Report number of blocks by type of chain
/// @param url
/// @param params
/// @return: number of blocks for each type
/// @throws QlcException
/// @throws IOException
+ (void)blocksCountByTypeWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return blocks info for blocks hash
/// @param url
/// @param params []string: blocks hash
/// @return: []block: blocks info
/// @throws QlcException
/// @throws IOException
+ (void)blocksInfoWithHashArr:(NSArray<NSString *> * _Nonnull)hashArr baseUrl:(NSString * _Nonnull)baseUrl successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Accept a specific block hash and return a consecutive blocks hash list， starting with this block, and traverse forward to the maximum number
/// @param url
/// @param params string : block hash to start at
/// int: get the maximum number of blocks, if set n to -1, will list blocks to open block
/// @return: []string: block hash list (if block not found, return error)
/// @throws QlcException
/// @throws IOException
+ (void)chainWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return a list of pairs of delegator and it’s balance for a specific representative account
/// @param url
/// @param params string: representative account address
/// @return: each delegator and it’s balance
/// @throws QlcException
/// @throws IOException
+ (void)delegatorsWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return number of delegators for a specific representative account
/// @param url
/// @param params string: representative account address
/// @return: int: number of delegators for the account
/// @throws QlcException
/// @throws IOException
+ (void)delegatorsCountWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return send block by send parameter and private key
/// @param url
/// @param params send parameter for the block
/// from: send address for the transaction
/// to: receive address for the transaction
/// tokenName: token name
/// amount: transaction amount
/// sender: optional, sms sender
/// receiver: optional, sms receiver
/// message: optional, sms message hash
/// string: private key
/// @return: block: send block
/// @throws QlcException
/// @throws IOException
+ (void)generateSendBlockWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return receive block by send block and private key
/// @param url
/// @param params block: send block
/// string: private key
/// @return: block: receive block
/// @throws QlcException
/// @throws IOException
+ (void)generateReceiveBlockWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return change block by account and private key
/// @param url
/// @param params string: account address
/// string: new representative account
/// string: private key
/// @return: block: change block
/// @throws QlcException
/// @throws IOException
+ (void)generateChangeBlockWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Check block base info, update chain info for the block, and broadcast block
/// @param url
/// @param params block: block
/// @return: string: hash of the block
/// @throws QlcException
/// @throws IOException
+ (void)processWithDic:(NSDictionary<NSString *, id> * _Nonnull)dic baseUrl:(NSString * _Nonnull)baseUrl successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return pairs of representative and its voting weight
/// @param url
/// @param params bool , optional, if not set or set false, will return representatives randomly, if set true, will sorting represetntative balance in descending order
/// @return: each representative and its voting weight
/// @throws QlcException
/// @throws IOException
+ (void)representativesWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return tokens of the chain
/// @param url
/// @param params
/// @return: []token: the tokens info
/// @throws QlcException
/// @throws IOException
+ (void)tokensWithBaseUrl:(NSString * _Nonnull)baseUrl successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return token info by token id
/// @param url
/// @param params string: token id
/// @return: token: token info
/// @throws QlcException
/// @throws IOException
+ (void)tokenInfoByIdWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return token info by token name
/// @param url
/// @param params string: token name
/// @return: token: token info
/// @throws QlcException
/// @throws IOException
+ (void)tokenInfoByNameWithToken:(NSString * _Nonnull)token baseUrl:(NSString * _Nonnull)baseUrl successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
/// Return the number of blocks (not include smartcontrant block) and unchecked blocks of chain
/// @param url
/// @param params
/// @return: count: int, number of blocks , not include smartcontrant block
/// unchecked: int, number of unchecked blocks
/// @throws QlcException
/// @throws IOException
+ (void)transactionsCountWithUrl:(NSString * _Nullable)url params:(NSArray * _Nullable)params successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
+ (void)rewards_getReceiveRewardBlockWithHashHex:(NSString * _Nonnull)hashHex baseUrl:(NSString * _Nonnull)baseUrl successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
+ (void)pov_getFittestHeaderWithBaseUrl:(NSString * _Nonnull)baseUrl successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC12QLCFramework7QLCUtil")
@interface QLCUtil : NSObject
+ (NSString * _Nonnull)signWithMessageHex:(NSString * _Nonnull)messageHex secretKey:(NSString * _Nonnull)secretKey publicKey:(NSString * _Nonnull)publicKey SWIFT_WARN_UNUSED_RESULT;
+ (BOOL)signOpenWithMessage:(NSString * _Nonnull)message publicKey:(NSString * _Nonnull)publicKey signature:(NSString * _Nonnull)signature SWIFT_WARN_UNUSED_RESULT;
+ (NSString * _Nonnull)generateSeed SWIFT_WARN_UNUSED_RESULT;
+ (BOOL)isValidSeedWithSeed:(NSString * _Nonnull)seed SWIFT_WARN_UNUSED_RESULT;
+ (NSString * _Nonnull)seedToPrivateKeyWithSeed:(NSString * _Nonnull)seed index:(uint8_t)index SWIFT_WARN_UNUSED_RESULT;
+ (NSString * _Nonnull)privateKeyToPublicKeyWithPrivateKey:(NSString * _Nonnull)privateKey SWIFT_WARN_UNUSED_RESULT;
+ (NSString * _Nonnull)publicKeyToAddressWithPublicKey:(NSString * _Nonnull)publicKey SWIFT_WARN_UNUSED_RESULT;
+ (NSString * _Nonnull)addressToPublicKeyWithAddress:(NSString * _Nonnull)address SWIFT_WARN_UNUSED_RESULT;
+ (BOOL)isValidAddressWithAddress:(NSString * _Nonnull)address SWIFT_WARN_UNUSED_RESULT;
+ (NSString * _Nonnull)seedToMnemonicWithSeed:(NSString * _Nonnull)seed SWIFT_WARN_UNUSED_RESULT;
+ (NSString * _Nonnull)mnemonicToSeedWithMnemonic:(NSString * _Nonnull)mnemonic SWIFT_WARN_UNUSED_RESULT;
+ (BOOL)isValidMnemonicWithMnemonic:(NSString * _Nonnull)mnemonic SWIFT_WARN_UNUSED_RESULT;
+ (void)requestServerWorkWithWorkHash:(NSString * _Nonnull)workHash resultHandler:(void (^ _Nonnull)(NSString * _Nonnull))resultHandler;
+ (void)signAndWorkWithDic:(NSDictionary * _Nonnull)dic publicKey:(NSString * _Nonnull)publicKey privateKey:(NSString * _Nonnull)privateKey resultHandler:(void (^ _Nonnull)(NSDictionary<NSString *, id> * _Nullable))resultHandler;
+ (void)sendAssetFrom:(NSString * _Nonnull)from tokenName:(NSString * _Nonnull)tokenName to:(NSString * _Nonnull)to amount:(NSUInteger)amount sender:(NSString * _Nullable)sender receiver:(NSString * _Nullable)receiver message:(NSString * _Nullable)message data:(NSString * _Nullable)data privateKey:(NSString * _Nonnull)privateKey baseUrl:(NSString * _Nonnull)baseUrl workInLocal:(BOOL)workInLocal successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
+ (void)receive_accountsPendingWithAddress:(NSString * _Nonnull)address baseUrl:(NSString * _Nonnull)baseUrl successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
+ (void)receive_blocksInfoWithBlockHash:(NSString * _Nonnull)blockHash receiveAddress:(NSString * _Nonnull)receiveAddress privateKey:(NSString * _Nonnull)privateKey baseUrl:(NSString * _Nonnull)baseUrl successHandler:(void (^ _Nonnull)(id _Nullable))successHandler failureHandler:(void (^ _Nonnull)(NSError * _Nullable, NSString * _Nullable))failureHandler;
+ (NSString * _Nonnull)getRandomStringOfLengthWithLength:(NSInteger)length SWIFT_WARN_UNUSED_RESULT;
+ (NSDictionary * _Nonnull)getSignBlockWithBlockDic:(NSDictionary * _Nonnull)blockDic privateKey:(NSString * _Nonnull)privateKey publicKey:(NSString * _Nonnull)publicKey SWIFT_WARN_UNUSED_RESULT;
+ (void)test;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


/// 随机字符串生成
SWIFT_CLASS("_TtC12QLCFramework12RandomString")
@interface RandomString : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC12QLCFramework8WorkUtil")
@interface WorkUtil : NSObject
+ (void)generateWorkOfOperationRandomWithHash:(NSString * _Nonnull)hash handler:(void (^ _Nonnull)(NSString * _Nonnull, BOOL))handler;
+ (NSString * _Nonnull)generateWorkOfSingleRandomWithHash:(NSString * _Nonnull)hash SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
