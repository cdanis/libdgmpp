//
//  main.m
//  dgmppDemo
//
//  Created by Артем Шиманский on 11.12.15.
//
//

#import <Foundation/Foundation.h>
#import <dgmpp/dgmpp.h>
#import <QuartzCore/QuartzCore.h>
#include <fstream>
#include <string>
#include <unordered_map>
#include <future>
#include <array>
#include <numeric>
#include <type_traits>
#include <sstream>
#include <queue>
#include <chrono>

using namespace dgmpp;

std::shared_ptr<Ship> addShip(std::shared_ptr<Engine> engine, NSString* dna, int level = 5) {
	NSMutableArray* components = [[dna componentsSeparatedByString:@":"] mutableCopy];
	TypeID shipTypeID = static_cast<TypeID>([components[0] intValue]);
	[components removeObjectAtIndex:0];
	
	auto pilot = engine->getGang()->addPilot();
	pilot->setAllSkillsLevel(level);
	auto ship = pilot->setShip(shipTypeID);
	
	engine->beginUpdates();
	std::list<TypeID> chargeIDs;
	for (NSString* component in components) {
		NSArray* c = [component componentsSeparatedByString:@";"];
		int32_t n = 1;
		TypeID typeID = static_cast<TypeID>([c[0] intValue]);
		if (typeID == TypeID::none)
			continue;
		if (c.count == 2)
			n = [c[1] intValue];
		bool isModule = true;
		for (int i = 0; i < n; i++) {
			if (isModule) {
				auto module = ship->addModule(typeID);
				if (!module) {
					isModule = false;
				}
				else
					module->setState(Module::State::active);
			}
			if (!isModule) {
				auto drone = ship->addDrone(typeID);
				if (!drone) {
					chargeIDs.push_back(typeID);
					break;
				}
			}
		}
	}
	for (auto typeID: chargeIDs) {
		for (auto module: ship->getModules()) {
			if (!module->getCharge())
				module->setCharge(typeID);
		}
	}
	engine->commitUpdates();
	return ship;
}

int main2()
{
	// future from a packaged_task
	/*std::packaged_task<int()> task([](){ return 7; }); // wrap the function
	std::future<int> f1 = task.get_future();  // get a future
	std::thread(std::move(task)).detach(); // launch on a thread
	
	// future from an async()
	std::future<int> f2 = std::async(std::launch::async, [](){ return 8; });
	
	// future from a promise
	std::promise<int> p;
	std::future<int> f3 = p.get_future();
	std::thread( [](std::promise<int>& p){ p.set_value(9); },
				std::ref(p) ).detach();
	
	std::cout << "Waiting...";
	f1.wait();
	f2.wait();
	f3.wait();
	
	auto b = f1.valid();
	auto i = f1.get();
	b = f1.valid();

	i = f1.get();
	i = f1.get();
	i = f1.get();

	std::cout << "Done!\nResults are: "
	<< f1.get() << ' ' << f2.get() << ' ' << f3.get() << '\n';*/
	
	for (int i = 0; i < 10; i++) {
	
	auto t0 = CACurrentMediaTime();
	auto b = 	sqlite3_threadsafe();

	std::mutex m;

	std::future<bool> f[1000];
	for (auto& ff: f) {
		ff = std::async(std::launch::async, [&]() -> bool {
//			m.lock();
			std::shared_ptr<Engine> engine = std::make_shared<Engine>(std::make_shared<SqliteConnector>("/Users/shimanski/Documents/git/EVEUniverse/dbTools/dbinit/dgm.sqlite"));
			auto request = engine->getSqlConnector()->getReusableFetchRequest("select * from invTypes");
//			auto request = std::make_shared<SqliteFetchRequest>("select * from invTypes");
			auto result = engine->getSqlConnector()->exec(request);
//			m.unlock();
		for (int j = 0; j < 1000; j++)
			result->next();
//			while (result->next()) {
//			}
			return true;
		});
	}
	for (auto& ff: f)
		ff.wait();
	auto t1 = CACurrentMediaTime();
	
	auto t = t1 - t0;
		NSLog(@"%f", t);
	}
	return 0;
}

struct Str {
	int i;
};

constexpr Str v[] = {{1},{2},{3},{4},{5}};

constexpr const Str& vv(int i) {
	for (int j = 0; j < sizeof(v); j++) {
		if (v[j].i == i)
			return v[j];
	}
	return v[0];
}

template<int I> struct fact {
	static constexpr int val = I * fact<I-1>::val;
};


template<> struct fact<0> {
	static constexpr int val = 1;
};

template <std::size_t N>
constexpr std::array<char, N - 1> obf(const char (&s)[N]) {
	std::array<char, N - 1> result;
	for (int i = 0; i < N - 1; i++) {
		result[i] = s[i] ^ 0x55; //Можно выбрать другое значение для XOR
	}
	return result;
}

template<size_t N>
std::string de_obf(const std::array<char, N>& a) {
	std::string s;
	std::transform(a.begin(), a.end(), std::back_inserter(s), [](auto c) -> char {return c ^ 0x55;});
	return s;
}

const auto s = obf("hello world");

namespace my {
constexpr std::size_t sfCount = 10;
constexpr int expIterations = 10;

constexpr double pow(double x, int y) {
	return y == 0 ? 1.0 : x * pow(x, y-1);
}

constexpr int factorial(int x) {
	return x == 0 ? 1 : x * factorial(x-1);
}

constexpr Float exp(Float x, int n = expIterations) {
	return n == 0 ? 1 : exp(x, n-1) + pow(x,n) / factorial(n);
};

constexpr Float sf(int n) {
	return exp(-static_cast<Float>(n * n) / 7.1289);
}

template<class Function, std::size_t... Indices>
constexpr auto make_array_helper(Function f, std::index_sequence<Indices...>)
-> std::array<typename std::result_of<Function(std::size_t)>::type, sizeof...(Indices)>
{
	return {{ f(Indices)... }};
}

template<int N, class Function>
constexpr auto make_array(Function f)
-> std::array<typename std::result_of<Function(std::size_t)>::type, N>
{
	return make_array_helper(f, std::make_index_sequence<N>{});
}

constexpr auto stackingFactor = make_array<sfCount>(sf);
}

template<typename InputIterator, typename Output>
Output multiply(InputIterator first, InputIterator last, Output value, bool stacking)
{
	if (stacking)
	{
		static std::vector<Float> pExp;
		long n = std::distance(first, last);
		for (long i = pExp.size(); i < n; i++) {
			Float j = i;
			pExp.push_back(std::exp(- j * j / 7.1289));
		}
		for (int i = 0; first != last; first++, i++)
			value *= static_cast<Float>(1.0 + (*first - 1.0) * pExp[i]);
	}
	else
	{
		for (; first != last; first++)
			value *= *first;
	}
	return value;
}

template <typename Iterator, typename F> struct TransformIterator {
//	using Iterator = std::iterator<Traits, T>;
	
//	TransformIterator(const Iterator& i, const F& f): iterator(i), function(f) {}
	
	TransformIterator& operator++() {
		++iterator;
		return *this;
	}

	TransformIterator& operator++(int) {
		iterator++;
		return *this;
	}

	TransformIterator& operator--() {
		--iterator;
		return *this;
	}

	TransformIterator& operator--(int) {
		iterator--;
		return *this;
	}

	auto operator*() const {
		return function(*iterator);
	}
	
	template <typename Iterator2, typename F2>
	bool operator!=(const TransformIterator<Iterator2, F2>& other) const {
		return iterator != other.iterator;
	}
	
	Iterator iterator;
	F function;
};

template <typename Iterator, typename F> TransformIterator<Iterator, F> MakeTransformIterator(Iterator&& i, F&& f) {
	return {std::forward<Iterator>(i), std::forward<F>(f)};
//	return TransformIterator<Iterator, F> {std::forward<Iterator>(i), std::forward<F>(f)};
}

struct C {
	int i = 0;
	void fun() {
		
	}
	
};

template <typename... Args>
struct KeyComparator {
	using Key = std::tuple<Args...>;
	
	bool operator()(const Key& lhs, const Key& rhs) const {
		return lhs < rhs;
	}
	
	template <typename... Args2, size_t... Is>
	std::tuple<Args2...> get(const Key& lhs, std::index_sequence<Is...>) const {
		return std::make_tuple(std::get<Is>(lhs)...);
	}
	
	template <typename... Args2>
	bool operator()(const Key& lhs, const std::tuple<Args2...>& rhs) const {
		return get<Args2...>(lhs, std::index_sequence_for<Args2...>{}) < rhs;
	}
	
	template <typename... Args2>
	bool operator()(const std::tuple<Args2...>& lhs, const Key& rhs) const {
		return lhs < get<Args2...>(rhs, std::index_sequence_for<Args2...>{});
	}
	
	typedef void is_transparent;
};

template<typename C, typename K> std::pair<typename C::iterator, typename C::iterator> equal_range (const C& c, const K& k) {
	return std::make_pair(c.lower_bound(k), c.upper_bound(k));
}

bool funn(int i) {
	std::cout << "funn(" << i << ")\n";
	return i < 3;
}

template<typename Rep, typename Period = std::chrono::seconds>
class rate {
public:
	using rep = Rep;
	using period = Period;
	
	constexpr explicit rate(const Rep& rep) : rep_(rep) {}
	
	template<typename Period2>
	constexpr operator rate<Rep, Period2> () {
		using r = std::ratio_divide<typename Period::period::ratio, typename Period2::period::ratio>;
		return rate<Rep, Period2>{rep_ * r::den / r::num};
	};
	
	Rep count() const {return rep_;}
	
	auto operator+ (const rate<Rep, Period>& other) {
		return rate<Rep, Period>(rep_ + other.rep_);
	}

	auto operator- (const rate<Rep, Period>& other) {
		return rate<Rep, Period>(rep_ + other.rep_);
	}

	auto operator* (const rate<Rep, Period>& other) {
		return rate<Rep, Period>(rep_ * other.rep_);
	}
	
	auto operator/ (const rate<Rep, Period>& other) {
		return rate<Rep, Period>(rep_ / other.rep_);
	}

	rate<Rep, Period>& operator+= (const rate<Rep, Period>& other) {
		rep_ += other.rep_;
		return *this;
	}

	rate<Rep, Period>& operator-= (const rate<Rep, Period>& other) {
		rep_ -= other.rep_;
		return *this;
	}

	rate<Rep, Period>& operator*= (const rate<Rep, Period>& other) {
		rep_ *= other.rep_;
		return *this;
	}
	
	rate<Rep, Period>& operator/= (const rate<Rep, Period>& other) {
		rep_ /= other.rep_;
		return *this;
	}

private:
	Rep rep_;
};

namespace dgmpp3 {
	using Float = double;
	using TypeID = dgmpp::TypeID;
	using GroupID = dgmpp::GroupID;
	using CategoryID = dgmpp::CategoryID;
	using AttributeID = dgmpp::AttributeID;
	using EffectID = dgmpp::EffectID;
	using ModifierID = int;
	using SchematicID = int;
	using GigaJoule = Float;
	using Percent = Float;
	
	template <typename... Args>
	struct array_type {};
	
	template <typename T, typename... Args>
	struct array_type<T, Args...> {
		using type = T;
	};
	
	template <>
	struct array_type<> {
		using type = void;
	};
	
	template <typename T, typename... Args>
	constexpr std::array<T, sizeof...(Args)> make_array(Args... args) {
		return { args... };
	}
	
	//  template <typename T>
	//std::array<T, 0> make_array() {
	//      return {};
	//}
	
	namespace MetaInfo {
		
		
		struct Attribute {
			AttributeID attributeID;
			AttributeID maxAttributeID;
			Float       defaultValue;
			bool        isStackable;
			bool        highIsGood;
			
			Attribute(const Attribute& other) = delete;
			Attribute(Attribute&& other) = delete;
			Attribute& operator= (const Attribute& other) = delete;
			Attribute& operator= (Attribute&& other) = delete;
			~Attribute() = default;
			
		};
		
		struct Modifier {
			enum class ModifierType {
				item,
				location,
				locationGroup,
				locationRequiredSkill,
				ownerRequiredSkill,
				locationRequiredDomainSkill,
			};
			
			enum class Association {
				preAssignment,
				modAdd,
				modSub,
				preDiv,
				preMul,
				postPercent,
				postDiv,
				postMul,
				postAssignment,
				skillTime,
				addRate,
				subRate
			};
			
			enum class Domain {
				self,
				character,
				ship,
				gang,
				area,
				target,
				other,
				structure
			};
			
			union Requirement {
				TypeID  typeID;
				GroupID groupID;
				Domain  domain;
				constexpr Requirement(TypeID typeID) : typeID(typeID) {}
				constexpr Requirement(GroupID groupID) : groupID(groupID) {}
				constexpr Requirement(Domain domain) : domain(domain) {}
			};
			
			ModifierType    type;
			Association     association;
			Domain          domain;
			
			AttributeID     modifiedAttributeID;
			AttributeID     modifyingAttributeID;
			
			Requirement     require;
			
			constexpr Modifier(ModifierType type,
							   Association association,
							   Domain domain,
							   AttributeID modifiedAttributeID,
							   AttributeID modifyingAttributeID)
			: type(type), association(association), domain(domain), modifiedAttributeID(modifiedAttributeID), modifyingAttributeID(modifyingAttributeID), require(TypeID::none) {}
			
			constexpr Modifier(ModifierType type,
							   Association association,
							   Domain domain,
							   AttributeID modifiedAttributeID,
							   AttributeID modifyingAttributeID,
							   TypeID require)
			: type(type), association(association), domain(domain), modifiedAttributeID(modifiedAttributeID), modifyingAttributeID(modifyingAttributeID), require(require) {}
			
			constexpr Modifier(ModifierType type,
							   Association association,
							   Domain domain,
							   AttributeID modifiedAttributeID,
							   AttributeID modifyingAttributeID,
							   GroupID require)
			: type(type), association(association), domain(domain), modifiedAttributeID(modifiedAttributeID), modifyingAttributeID(modifyingAttributeID), require(require) {}
			
			constexpr Modifier(ModifierType type,
							   Association association,
							   Domain domain,
							   AttributeID modifiedAttributeID,
							   AttributeID modifyingAttributeID,
							   Domain require)
			: type(type), association(association), domain(domain), modifiedAttributeID(modifiedAttributeID), modifyingAttributeID(modifyingAttributeID), require(require) {}
			
			Modifier(const Modifier& other) = delete;
			Modifier(Modifier&& other) = delete;
			Modifier& operator= (const Modifier& other) = delete;
			Modifier& operator= (Modifier&& other) = delete;
			~Modifier() = default;
		};
		
		struct Effect {
			enum class Category {
				generic,
				active,
				target,
				passive,
				overloaded,
				dungeon,
				system
			};
			
			EffectID    effectID;
			Category    category;
			bool        isAssistance;
			bool        isOffensive;
			virtual dgmpp2::slice<const Modifier* const*> modifiers() const = 0;
			//std::initializer_list<const ref<const Modifier>> modifiers;
			
			constexpr Effect(EffectID effectID, Category category, bool isAssistance, bool isOffensive)
			: effectID(effectID), category(category), isAssistance(isAssistance), isOffensive(isOffensive) {};
			
			Effect(const Effect& other) = delete;
			Effect& operator= (const Effect& other) = delete;
			Effect& operator= (Effect&& other) = delete;
			~Effect() = default;
		protected:
			Effect(Effect&& other) = default;
			
		};
		
		template<typename Modifiers>
		struct EffectImpl : public Effect {
			
			constexpr EffectImpl(EffectID effectID, Category category, bool isAssistance, bool isOffensive, const Modifiers& modifiers)
			: Effect(effectID, category, isAssistance, isOffensive), modifiers_(modifiers) {};
			
			
			virtual dgmpp2::slice<const Modifier* const*> modifiers() const override {
				return { nullptr, nullptr };
			}
		private:
			Modifiers modifiers_;
		};
		
		template<typename Modifiers>
		constexpr EffectImpl<Modifiers> MakeEffect(EffectID effectID, Effect::Category category, bool isAssistance, bool isOffensive, const Modifiers& modifiers) {
			return { effectID, category, isAssistance, isOffensive, modifiers };
		}
		
		struct Type {
			TypeID      typeID;
			GroupID     groupID;
			CategoryID  categoryID;
			
			virtual dgmpp2::slice<const std::pair<const Attribute*, Float>*> attributes() const = 0;
			virtual dgmpp2::slice<const Effect* const*> effects() const = 0;
			virtual dgmpp2::slice<const TypeID*> requiredSkills() const = 0;
			
			//          std::initializer_list<std::pair<const Attribute&, Float>>   attributes;
			//          std::initializer_list<ref<const Effect>>                    effects;
			//          std::initializer_list<const TypeID>                           requiredSkills;
			
			constexpr Type(TypeID typeID, GroupID groupID, CategoryID categoryID)
			: typeID(typeID), groupID(groupID), categoryID(categoryID) {}
			
			
			Type(const Type& other) = delete;
			Type& operator= (const Type& other) = delete;
			Type& operator= (Type&& other) = delete;
			~Type() = default;
			
			bool requireSkill(TypeID skillID) const {
				return false;
				//return std::find(requiredSkills.begin(), requiredSkills.end(), skillID) != requiredSkills.end();
			}
		protected:
			Type(Type&& other) = default;
		};
		
		template <size_t A, size_t E, size_t S>
		struct TypeImpl : public Type {
			using Attributes = std::array<std::pair<const Attribute*, Float>, A>;
			using Effects = std::array<const Effect*, E>;
			using RequiredSkills = std::array<TypeID, S>;
			
			constexpr TypeImpl(TypeID typeID, GroupID groupID, CategoryID categoryID, const Attributes& attributes, const Effects& effects, const RequiredSkills& requiredSkills)
			: Type(typeID, groupID, categoryID), attributes_(attributes), effects_(effects), requiredSkills_(requiredSkills) {}
			
			virtual dgmpp2::slice<const std::pair<const Attribute*, Float>*> attributes() const override {
				return { nullptr, nullptr };
			}
			
			virtual dgmpp2::slice<const Effect* const*> effects() const override {
				return { nullptr, nullptr };
			}
			
			virtual dgmpp2::slice<const TypeID*> requiredSkills() const override {
				return { nullptr, nullptr };
			}
			
			
		private:
			Attributes attributes_;
			Effects effects_;
			RequiredSkills requiredSkills_;
		};
		
		template <size_t A, size_t E, size_t S>
		constexpr TypeImpl<A, E, S> MakeType(TypeID typeID, GroupID groupID, CategoryID categoryID,
											 const std::array<std::pair<const Attribute*, Float>, A>& attributes,
											 const std::array<const Effect*, E>& effects,
											 const std::array<TypeID, S>& requiredSkills) {
			return { typeID, groupID, categoryID, attributes, effects, requiredSkills };
		}
		
	}
}


namespace dgmpp3 {
	namespace SDE {
		namespace Attributes {
			constexpr MetaInfo::Attribute isOnline = { AttributeID::isOnline, AttributeID::none, 0, true, true };
			constexpr MetaInfo::Attribute damage = { AttributeID::damage, AttributeID::none, 0, true, true };
			
			constexpr const MetaInfo::Attribute* attributes[] = { &isOnline, &damage };
		}
		namespace Modifiers {
			constexpr MetaInfo::Modifier modifier1 = { MetaInfo::Modifier::ModifierType::item, MetaInfo::Modifier::Association::addRate, MetaInfo::Modifier::Domain::ship, AttributeID::shieldCharge, AttributeID::shieldBonus };
		}
		namespace Effects {
			constexpr auto shieldBoosting = MetaInfo::MakeEffect ( EffectID::shieldBoosting, MetaInfo::Effect::Category::active, false, false, make_array<const MetaInfo::Modifier*>() );
		}
		
		template <typename... Args>
		constexpr auto attributes_(Args&&... args) {
			return make_array<std::pair<const MetaInfo::Attribute*, Float>, Args...>(std::forward<Args>(args)...);
		}
		
		namespace Types {
			constexpr auto dominix = MetaInfo::MakeType(TypeID::dominix, GroupID::battleship, CategoryID::ship,
														attributes_(std::make_pair(&Attributes::isOnline, 1.0)),
														make_array<const MetaInfo::Effect*>(&Effects::shieldBoosting),
														make_array<TypeID>(TypeID::gallenteBattleship));
			
			constexpr const MetaInfo::Type* types[] = { &dominix };
		}
	}
}

constexpr size_t cstrlen(const char* s) {
	size_t l = 0;
	for (; s[l]; l++);
	return l;
}

struct cstring {
	constexpr cstring(const char* s) : ptr(s), size(cstrlen(s)) {};
	const char* ptr;
	size_t size;
};

template<> struct std::hash<cstring> {
	constexpr size_t operator()(const cstring& s) {
		size_t v = 0x811c9dc5;
		for (int i = 0; i < s.size; i++) {
			v *= 0x01000193;
			v ^= s.ptr[i];
		}
		return v;
	}
};

template<typename T>
constexpr size_t type_id() {
	return std::hash<cstring>()(cstring(__PRETTY_FUNCTION__));
}



template <typename Rep> struct Unit;

template<typename A, typename B, typename Rep = double>
struct Mul : public Unit<Rep> {};

template<typename A, typename B, typename Rep = double>
struct Div : public Unit<Rep> {};

/*
 
 (M*S)/(S/M)/M = M*M/S/S/M
 */

//struct One{};

template<typename T> struct Normalize { using type = T; };
template<typename A, typename B, typename C> struct Normalize<Mul<A,Mul<B, C>>> { using type = typename Normalize<Mul<Mul<typename Normalize<A>::type, typename Normalize<B>::type>, typename Normalize<C>::type>>::type; };
template<typename A, typename B, typename C> struct Normalize<Mul<A,Div<B, C>>> { using type = typename Normalize<Div<Mul<typename Normalize<A>::type, typename Normalize<B>::type>, typename Normalize<C>::type>>::type; };
template<typename A, typename B, typename C> struct Normalize<Div<A,Div<B, C>>> { using type = typename Normalize<Div<Mul<typename Normalize<A>::type, typename Normalize<C>::type>, typename Normalize<B>::type>>::type; };
template<typename A, typename B, typename C> struct Normalize<Div<A,Mul<B, C>>> { using type = typename Normalize<Div<Div<typename Normalize<A>::type, typename Normalize<B>::type>, typename Normalize<C>::type>>::type; };
template<typename A, typename B> struct Normalize<Mul<A, B>> { using type = Mul<typename Normalize<A>::type, typename Normalize<B>::type>; };
template<typename A, typename B> struct Normalize<Div<A, B>> { using type = Div<typename Normalize<A>::type, typename Normalize<B>::type>; };

template<typename A, typename B> struct Shift { using type = Div<A, B>; };
template<typename A> struct Shift<A, A> { using type = void; };
template<typename A, typename B> struct Shift<Mul<A, B>, B> { using type = A; };
template<typename A, typename B> struct Shift<Div<A, B>, A> { using type = Div<void, B>; };
template<typename A, typename B, typename C> struct Shift<Mul<A, B>, C> { using type = Mul<typename Shift<A, C>::type, B>; };
template<typename A, typename B, typename C> struct Shift<Div<A, B>, C> { using type = Div<typename Shift<A, C>::type, B>; };

template<typename T> struct Reduce { using type = T; };
template<typename T> struct Reduce<Div<T, T>> { using type = void; };
template<typename T> struct Reduce<Div<T, void>> { using type = T; };
template<typename T> struct Reduce<Mul<T, void>> { using type = T; };
template<typename T> struct Reduce<Mul<void, T>> { using type = T; };
template<typename A, typename B> struct Reduce<Div<A, B>> { using type = typename Shift<typename Reduce<A>::type, B>::type ; };

template<typename T>
using Simplify = typename Normalize<typename Reduce<typename Normalize<T>::type>::type>::type;

template <typename Rep>
struct Unit {
	constexpr Unit(const Rep& value) : value(value) {}
	constexpr Unit() : value(0) {}
	Rep value;
	
	Unit<Rep> operator+ (const Unit<Rep>& other) {
		return {value + other.value};
	}
	
	Unit<Rep> operator- (const Unit<Rep>& other) {
		return {value - other.value};
	}

//	Unit<Rep> operator* (const Unit<Rep>& other) {
//		return {value * other.value};
//	}
//
//	Unit<Rep> operator/ (const Unit<Rep>& other) {
//		return {value / other.value};
//	}
	
	template<typename T, typename = std::enable_if_t<std::is_arithmetic_v<T>>>
	Unit<Rep> operator* (const T& other) {
		return {value * other};
	}

	template<typename T, typename = std::enable_if_t<std::is_arithmetic_v<T>>>
	Unit<Rep> operator/ (const T& other) {
		return {value / other};
	}
};

template<typename A, typename B, typename Rep, typename = std::enable_if_t<std::is_base_of_v<Unit<Rep>, A> && std::is_base_of_v<Unit<Rep>, B>>>
auto operator* (A a, B b) {
	return Simplify<Mul<A, B>> ();
}


struct Meter: public Unit<double> {};
struct Second: public Unit<double> {};

template <typename T, typename Enabled = void> struct Sort {};

template <typename A, typename B> struct Sort<Mul<A, B>, std::enable_if_t<(type_id<A>() < type_id<B>())>> {
	typedef Mul<A,B> type;
};

template <typename A, typename B> struct Sort<Mul<A, B>, std::enable_if_t<(type_id<A>() >= type_id<B>())>> {
	typedef Mul<B,A> type;
};

template<typename T>
constexpr size_t hash_combine_v(size_t seed, const T& t) {
	return seed ^ (std::hash<T>()(t) + 0x9e3779b9 + (seed << 6) + (seed >> 2));
}

void addFacility(std::shared_ptr<dgmpp::Planet> planet1, dgmpp2::Planet& planet2, dgmpp::TypeID typeID, int64_t identifier) {
	planet1->addFacility(typeID, identifier);
	planet2.add(typeID, identifier);
}

void route(std::shared_ptr<dgmpp::Planet> planet1, dgmpp2::Planet& planet2, int64_t from, int64_t to, dgmpp::TypeID typeID) {
	planet1->addRoute(planet1->findFacility(from), planet1->findFacility(to), Commodity(planet1->getEngine(), typeID, 0));
	planet2.add({planet2[from], planet2[to], dgmpp2::Commodity(typeID)});
}

void setSchematic(std::shared_ptr<dgmpp::Planet> planet1, dgmpp2::Planet& planet2, int64_t identifier, dgmpp::SchematicID schematicID) {
	std::dynamic_pointer_cast<dgmpp::IndustryFacility>(planet1->findFacility(identifier))->setSchematic(schematicID);
	dynamic_cast<dgmpp2::Factory*>(planet2[identifier])->schematic(schematicID);
}

void setLaunchTime(std::shared_ptr<dgmpp::Planet> planet1, dgmpp2::Planet& planet2, int64_t identifier, double launchTime) {
	std::dynamic_pointer_cast<ExtractorControlUnit>(planet1->findFacility(identifier))->setLaunchTime(launchTime);
	dynamic_cast<dgmpp2::ExtractorControlUnit*>(planet2[identifier])->launchTime(std::chrono::seconds(static_cast<long long>(launchTime)));

}

void setInstallTime(std::shared_ptr<dgmpp::Planet> planet1, dgmpp2::Planet& planet2, int64_t identifier, double installTime) {
	std::dynamic_pointer_cast<ExtractorControlUnit>(planet1->findFacility(identifier))->setInstallTime(installTime);
	dynamic_cast<dgmpp2::ExtractorControlUnit*>(planet2[identifier])->installTime(std::chrono::seconds(static_cast<long long>(installTime)));
}

void setExpiryTime(std::shared_ptr<dgmpp::Planet> planet1, dgmpp2::Planet& planet2, int64_t identifier, double expiryTime) {
	std::dynamic_pointer_cast<ExtractorControlUnit>(planet1->findFacility(identifier))->setExpiryTime(expiryTime);
	dynamic_cast<dgmpp2::ExtractorControlUnit*>(planet2[identifier])->expiryTime(std::chrono::seconds(static_cast<long long>(expiryTime)));
}

void setCycleTime(std::shared_ptr<dgmpp::Planet> planet1, dgmpp2::Planet& planet2, int64_t identifier, double cycleTime) {
	std::dynamic_pointer_cast<ExtractorControlUnit>(planet1->findFacility(identifier))->setCycleTime(cycleTime);
	dynamic_cast<dgmpp2::ExtractorControlUnit*>(planet2[identifier])->cycleTime(std::chrono::seconds(static_cast<long long>(cycleTime)));
}

void setQuantityPerCycle(std::shared_ptr<dgmpp::Planet> planet1, dgmpp2::Planet& planet2, int64_t identifier, uint32_t quantityPerCycle) {
	std::dynamic_pointer_cast<ExtractorControlUnit>(planet1->findFacility(identifier))->setQuantityPerCycle(quantityPerCycle);
	dynamic_cast<dgmpp2::ExtractorControlUnit*>(planet2[identifier])->quantityPerCycle(quantityPerCycle);
}


void testPI(std::shared_ptr<Engine> const& engine) {
	using namespace dgmpp;
	double lastUpdateTime = 1452068276;
	auto planet = engine->setPlanet(TypeID::none);
	planet->setLastUpdate(lastUpdateTime - lastUpdateTime);
	planet->addFacility(TypeID::barrenCommandCenter, 1019338918550);
	planet->addFacility(TypeID::barrenStorageFacility, 1019339001861);
	planet->addFacility(TypeID::barrenAdvancedIndustryFacility, 1019339001862);
	planet->addFacility(TypeID::barrenLaunchpad, 1019339001863);
	planet->addFacility(TypeID::barrenAdvancedIndustryFacility, 1019339001865);
	planet->addFacility(TypeID::barrenBasicIndustryFacility, 1019339001870);
	planet->addFacility(TypeID::barrenBasicIndustryFacility, 1019339001873);
	planet->addFacility(TypeID::barrenBasicIndustryFacility, 1019339001877);
	planet->addFacility(TypeID::barrenExtractorControlUnit, 1019339001881);
	planet->addFacility(TypeID::barrenBasicIndustryFacility, 1019339001884);
	planet->addFacility(TypeID::barrenBasicIndustryFacility, 1019339001885);
	planet->addFacility(TypeID::barrenBasicIndustryFacility, 1019339001888);
	planet->addFacility(TypeID::barrenAdvancedIndustryFacility, 1019586416755);
	planet->addFacility(TypeID::barrenExtractorControlUnit, 1019741064685);
	
	planet->addRoute(planet->findFacility(1019339001861), planet->findFacility(1019339001877), Commodity(engine, TypeID::nobleMetals, 0));
	planet->addRoute(planet->findFacility(1019339001861), planet->findFacility(1019339001873), Commodity(engine, TypeID::nobleMetals, 0));
	planet->addRoute(planet->findFacility(1019339001861), planet->findFacility(1019339001870), Commodity(engine, TypeID::nobleMetals, 0));
	planet->addRoute(planet->findFacility(1019339001861), planet->findFacility(1019339001865), Commodity(engine, TypeID::preciousMetals, 0));
	planet->addRoute(planet->findFacility(1019339001861), planet->findFacility(1019339001862), Commodity(engine, TypeID::preciousMetals, 0));
	planet->addRoute(planet->findFacility(1019339001861), planet->findFacility(1019586416755), Commodity(engine, TypeID::preciousMetals, 0));
//	planet->addRoute(planet->findFacility(1019339001861), planet->findFacility(1019586416755), Commodity(engine, TypeID::preciousMetals, 0));
	
	planet->addRoute(planet->findFacility(1019339001862), planet->findFacility(1019339001863), Commodity(engine, TypeID::mechanicalParts, 0));
	planet->addRoute(planet->findFacility(1019339001865), planet->findFacility(1019339001863), Commodity(engine, TypeID::biocells, 0));
	planet->addRoute(planet->findFacility(1019339001870), planet->findFacility(1019339001861), Commodity(engine, TypeID::preciousMetals, 0));
	planet->addRoute(planet->findFacility(1019339001873), planet->findFacility(1019339001861), Commodity(engine, TypeID::preciousMetals, 0));
	planet->addRoute(planet->findFacility(1019339001877), planet->findFacility(1019339001861), Commodity(engine, TypeID::preciousMetals, 0));
	planet->addRoute(planet->findFacility(1019339001881), planet->findFacility(1019339001861), Commodity(engine, TypeID::nobleMetals, 0));
	planet->addRoute(planet->findFacility(1019339001884), planet->findFacility(1019339001861), Commodity(engine, TypeID::biofuels, 0));
	planet->addRoute(planet->findFacility(1019339001885), planet->findFacility(1019339001861), Commodity(engine, TypeID::biofuels, 0));
	planet->addRoute(planet->findFacility(1019339001888), planet->findFacility(1019339001861), Commodity(engine, TypeID::biofuels, 0));
	planet->addRoute(planet->findFacility(1019586416755), planet->findFacility(1019339001863), Commodity(engine, TypeID::biocells, 0));
	planet->addRoute(planet->findFacility(1019741064685), planet->findFacility(1019339001861), Commodity(engine, TypeID::carbonCompounds, 0));
	
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001862))->setSchematic(SchematicID::mechanicalParts);
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001865))->setSchematic(SchematicID::biocells);
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001870))->setSchematic(SchematicID::preciousMetals);
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001873))->setSchematic(SchematicID::preciousMetals);
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001877))->setSchematic(SchematicID::preciousMetals);
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001884))->setSchematic(SchematicID::biofuels);
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001885))->setSchematic(SchematicID::biofuels);
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001888))->setSchematic(SchematicID::biofuels);
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019586416755))->setSchematic(SchematicID::biocells);
	
	std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019339001881))->setCycleTime(120 * 60);
	std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019339001881))->setQuantityPerCycle(4741);
	std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019339001881))->setLaunchTime(1452068276 - lastUpdateTime);
	std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019339001881))->setInstallTime(1452068276 - lastUpdateTime);
	std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019339001881))->setExpiryTime(1452500276 - lastUpdateTime);
	
	std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019741064685))->setCycleTime(120 * 60);
	std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019741064685))->setQuantityPerCycle(6425);
	std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019741064685))->setLaunchTime(1452068276 - lastUpdateTime);
	std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019741064685))->setInstallTime(1452068276 - lastUpdateTime);
	std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019741064685))->setExpiryTime(1452500276 - lastUpdateTime);
	
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019586416755))->setLaunchTime(0);
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001865))->setLaunchTime(0);
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001870))->setLaunchTime(0);
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001873))->setLaunchTime(0);
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001877))->setLaunchTime(0);
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001884))->setLaunchTime(0);
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001885))->setLaunchTime(0);
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001888))->setLaunchTime(0);
	std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019586416755))->setLaunchTime(0);
	
	double endTime = planet->simulate();
	auto fac1 = planet->findFacility(1019339001877);
	auto fac2 = planet->findFacility(1019339001873);
	auto fac3 = planet->findFacility(1019339001870);
	auto i = fac1->getIncomming(Commodity(engine, TypeID::preciousMetals, 0)).getQuantity() +
			fac2->getIncomming(Commodity(engine, TypeID::preciousMetals, 0)).getQuantity() +
			fac3->getIncomming(Commodity(engine, TypeID::preciousMetals, 0)).getQuantity();
	
//	i = planet->findFacility(1019339001861)->getIncomming(Commodity(engine, TypeID::nobleMetals, 0)).getQuantity();
//	auto ecu1 = planet->findFacility(1019339001881);
//	auto ecu2 = planet->findFacility(1019741064685);
//	i = ecu1->getIncomming(Commodity(engine, TypeID::nobleMetals, 0)).getQuantity();
//	i += ecu2->getIncomming(Commodity(engine, TypeID::carbonCompounds, 0)).getQuantity();
	std::cout <<"endTime1:" << endTime << "; income1: " << i << std::endl;
}

void testPI2() {
	using namespace std::chrono_literals;
	
	auto planet = dgmpp2::Planet();
	auto lastUpdateTime = 1452068276s;
//	planet.lastUpdate(0s);
	
	planet.add(TypeID::barrenCommandCenter, 1019338918550);
	planet.add(TypeID::barrenStorageFacility, 1019339001861);
	planet.add(TypeID::barrenAdvancedIndustryFacility, 1019339001862);
	planet.add(TypeID::barrenLaunchpad, 1019339001863);
	planet.add(TypeID::barrenAdvancedIndustryFacility, 1019339001865);
	planet.add(TypeID::barrenBasicIndustryFacility, 1019339001870);
	planet.add(TypeID::barrenBasicIndustryFacility, 1019339001873);
	planet.add(TypeID::barrenBasicIndustryFacility, 1019339001877);
	planet.add(TypeID::barrenExtractorControlUnit, 1019339001881);
	planet.add(TypeID::barrenBasicIndustryFacility, 1019339001884);
	planet.add(TypeID::barrenBasicIndustryFacility, 1019339001885);
	planet.add(TypeID::barrenBasicIndustryFacility, 1019339001888);
	planet.add(TypeID::barrenAdvancedIndustryFacility, 1019586416755);
	planet.add(TypeID::barrenExtractorControlUnit, 1019741064685);
	
	planet.add(dgmpp2::Route{planet[1019339001861], planet[1019339001877], dgmpp2::Commodity{TypeID::nobleMetals}});
	planet.add(dgmpp2::Route{planet[1019339001861], planet[1019339001873], dgmpp2::Commodity{TypeID::nobleMetals}});
	planet.add(dgmpp2::Route{planet[1019339001861], planet[1019339001870], dgmpp2::Commodity{TypeID::nobleMetals}});
	planet.add(dgmpp2::Route{planet[1019339001861], planet[1019339001865], dgmpp2::Commodity{TypeID::preciousMetals}});
	planet.add(dgmpp2::Route{planet[1019339001861], planet[1019339001862], dgmpp2::Commodity{TypeID::preciousMetals}});
	planet.add(dgmpp2::Route{planet[1019339001861], planet[1019586416755], dgmpp2::Commodity{TypeID::preciousMetals}});
//	planet.add(dgmpp2::Route{planet[1019339001861], planet[1019586416755], dgmpp2::Commodity{TypeID::preciousMetals}});

	planet.add(dgmpp2::Route{planet[1019339001862], planet[1019339001863], dgmpp2::Commodity{TypeID::mechanicalParts}});
	planet.add(dgmpp2::Route{planet[1019339001865], planet[1019339001863], dgmpp2::Commodity{TypeID::biocells}});
	planet.add(dgmpp2::Route{planet[1019339001870], planet[1019339001861], dgmpp2::Commodity{TypeID::preciousMetals}});
	planet.add(dgmpp2::Route{planet[1019339001873], planet[1019339001861], dgmpp2::Commodity{TypeID::preciousMetals}});
	planet.add(dgmpp2::Route{planet[1019339001877], planet[1019339001861], dgmpp2::Commodity{TypeID::preciousMetals}});
	planet.add(dgmpp2::Route{planet[1019339001881], planet[1019339001861], dgmpp2::Commodity{TypeID::nobleMetals}});
	planet.add(dgmpp2::Route{planet[1019339001884], planet[1019339001861], dgmpp2::Commodity{TypeID::biofuels}});
	planet.add(dgmpp2::Route{planet[1019339001885], planet[1019339001861], dgmpp2::Commodity{TypeID::biofuels}});
	planet.add(dgmpp2::Route{planet[1019339001888], planet[1019339001861], dgmpp2::Commodity{TypeID::biofuels}});
	planet.add(dgmpp2::Route{planet[1019586416755], planet[1019339001863], dgmpp2::Commodity{TypeID::biocells}});
	planet.add(dgmpp2::Route{planet[1019741064685], planet[1019339001861], dgmpp2::Commodity{TypeID::carbonCompounds}});

	dynamic_cast<dgmpp2::Factory*>(planet[1019339001862])->schematic(SchematicID::mechanicalParts);
	dynamic_cast<dgmpp2::Factory*>(planet[1019339001865])->schematic(SchematicID::biocells);
	dynamic_cast<dgmpp2::Factory*>(planet[1019339001870])->schematic(SchematicID::preciousMetals);
	dynamic_cast<dgmpp2::Factory*>(planet[1019339001873])->schematic(SchematicID::preciousMetals);
	dynamic_cast<dgmpp2::Factory*>(planet[1019339001877])->schematic(SchematicID::preciousMetals);
	dynamic_cast<dgmpp2::Factory*>(planet[1019339001884])->schematic(SchematicID::biofuels);
	dynamic_cast<dgmpp2::Factory*>(planet[1019339001885])->schematic(SchematicID::biofuels);
	dynamic_cast<dgmpp2::Factory*>(planet[1019339001888])->schematic(SchematicID::biofuels);
	dynamic_cast<dgmpp2::Factory*>(planet[1019586416755])->schematic(SchematicID::biocells);

	dynamic_cast<dgmpp2::ExtractorControlUnit*>(planet[1019339001881])->cycleTime(2h);
	dynamic_cast<dgmpp2::ExtractorControlUnit*>(planet[1019339001881])->quantityPerCycle(4741);
	dynamic_cast<dgmpp2::ExtractorControlUnit*>(planet[1019339001881])->launchTime(1452068276s - lastUpdateTime);
	dynamic_cast<dgmpp2::ExtractorControlUnit*>(planet[1019339001881])->installTime(1452068276s - lastUpdateTime);
	dynamic_cast<dgmpp2::ExtractorControlUnit*>(planet[1019339001881])->expiryTime(1452500276s - lastUpdateTime);

	dynamic_cast<dgmpp2::ExtractorControlUnit*>(planet[1019741064685])->cycleTime(2h);
	dynamic_cast<dgmpp2::ExtractorControlUnit*>(planet[1019741064685])->quantityPerCycle(6425);
	dynamic_cast<dgmpp2::ExtractorControlUnit*>(planet[1019741064685])->launchTime(1452068276s - lastUpdateTime);
	dynamic_cast<dgmpp2::ExtractorControlUnit*>(planet[1019741064685])->installTime(1452068276s - lastUpdateTime);
	dynamic_cast<dgmpp2::ExtractorControlUnit*>(planet[1019741064685])->expiryTime(1452500276s - lastUpdateTime);

//	dynamic_cast<dgmpp2::Factory*>(planet[1019586416755])->launchTime(0s);
//	dynamic_cast<dgmpp2::Factory*>(planet[1019339001865])->launchTime(0s);
//	dynamic_cast<dgmpp2::Factory*>(planet[1019339001870])->launchTime(0s);
//	dynamic_cast<dgmpp2::Factory*>(planet[1019339001873])->launchTime(0s);
//	dynamic_cast<dgmpp2::Factory*>(planet[1019339001877])->launchTime(0s);
//	dynamic_cast<dgmpp2::Factory*>(planet[1019339001884])->launchTime(0s);
//	dynamic_cast<dgmpp2::Factory*>(planet[1019339001885])->launchTime(0s);
//	dynamic_cast<dgmpp2::Factory*>(planet[1019339001888])->launchTime(0s);
//	dynamic_cast<dgmpp2::Factory*>(planet[1019586416755])->launchTime(0s);

	auto endTime = planet.run();
	auto fac1 = planet[1019339001877];
	auto fac2 = planet[1019339001873];
	auto fac3 = planet[1019339001870];
	auto i = fac1->income(TypeID::preciousMetals).quantity() +
			fac2->income(TypeID::preciousMetals).quantity() +
			fac3->income(TypeID::preciousMetals).quantity();
//	i = planet[1019339001861]->income(TypeID::nobleMetals).quantity();
//	auto free = fac->freeVolume();
	
//	auto ecu1 = planet[1019339001881];
//	auto ecu2 = planet[1019741064685];
//	i = ecu1->income(TypeID::nobleMetals).quantity() +
//		ecu2->income(TypeID::carbonCompounds).quantity();
	
	std::cout <<"endTime2:" << endTime.count() << "; income2: " << i << std::endl;

}

void testPI3(std::shared_ptr<Engine> const& engine) {
	using namespace dgmpp;
	auto planet1 = engine->setPlanet(TypeID::none);
	auto planet2 = dgmpp2::Planet();
	
	addFacility(planet1, planet2, TypeID::barrenStorageFacility, 10);

	for (int i = 30; i <= 45; i++)
		addFacility(planet1, planet2, TypeID::barrenBasicIndustryFacility, i);
	for (int i = 20; i <= 28; i++) {
		addFacility(planet1, planet2, TypeID::barrenExtractorControlUnit, i);
		setCycleTime(planet1, planet2, i, 2 * 3600);
		setQuantityPerCycle(planet1, planet2, i, 4000);
		setExpiryTime(planet1, planet2, i, 432000);
	}
	
	setSchematic(planet1, planet2, 30, dgmpp::SchematicID::nanoFactory);
	route(planet1, planet2, 10, 30, TypeID::industrialExplosives);
	route(planet1, planet2, 10, 30, TypeID::reactiveMetals);
	route(planet1, planet2, 10, 30, TypeID::ukomiSuperconductors);
	route(planet1, planet2, 30, 10, TypeID::nanoFactory);

	setSchematic(planet1, planet2, 31, dgmpp::SchematicID::industrialExplosives);
	route(planet1, planet2, 10, 31, TypeID::fertilizer);
	route(planet1, planet2, 10, 31, TypeID::polytextiles);
	route(planet1, planet2, 31, 10, TypeID::industrialExplosives);

	setSchematic(planet1, planet2, 32, dgmpp::SchematicID::reactiveMetals);
	route(planet1, planet2, 10, 32, TypeID::baseMetals);
	route(planet1, planet2, 32, 10, TypeID::reactiveMetals);

	setSchematic(planet1, planet2, 33, dgmpp::SchematicID::ukomiSuperconductor);
	route(planet1, planet2, 10, 33, TypeID::syntheticOil);
	route(planet1, planet2, 10, 33, TypeID::superconductors);
	route(planet1, planet2, 33, 10, TypeID::ukomiSuperconductors);

	setSchematic(planet1, planet2, 34, dgmpp::SchematicID::fertilizer);
	route(planet1, planet2, 10, 34, TypeID::bacteria);
	route(planet1, planet2, 10, 34, TypeID::proteins);
	route(planet1, planet2, 34, 10, TypeID::fertilizer);

	setSchematic(planet1, planet2, 35, dgmpp::SchematicID::polytextiles);
	route(planet1, planet2, 10, 35, TypeID::biofuels);
	route(planet1, planet2, 10, 35, TypeID::industrialFibers);
	route(planet1, planet2, 35, 10, TypeID::polytextiles);

	setSchematic(planet1, planet2, 36, dgmpp::SchematicID::syntheticOil);
	route(planet1, planet2, 10, 36, TypeID::electrolytes);
	route(planet1, planet2, 10, 36, TypeID::oxygen);
	route(planet1, planet2, 36, 10, TypeID::syntheticOil);

	setSchematic(planet1, planet2, 37, dgmpp::SchematicID::superconductors);
	route(planet1, planet2, 10, 37, TypeID::plasmoids);
	route(planet1, planet2, 10, 37, TypeID::water);
	route(planet1, planet2, 37, 10, TypeID::superconductors);

	setSchematic(planet1, planet2, 38, dgmpp::SchematicID::bacteria);
	route(planet1, planet2, 10, 38, TypeID::microorganisms);
	route(planet1, planet2, 38, 10, TypeID::bacteria);

	setSchematic(planet1, planet2, 39, dgmpp::SchematicID::proteins);
	route(planet1, planet2, 10, 39, TypeID::complexOrganisms);
	route(planet1, planet2, 39, 10, TypeID::proteins);

	setSchematic(planet1, planet2, 40, dgmpp::SchematicID::biofuels);
	route(planet1, planet2, 10, 40, TypeID::carbonCompounds);
	route(planet1, planet2, 40, 10, TypeID::biofuels);

	setSchematic(planet1, planet2, 41, dgmpp::SchematicID::industrialFibers);
	route(planet1, planet2, 10, 41, TypeID::autotrophs);
	route(planet1, planet2, 41, 10, TypeID::industrialFibers);

	setSchematic(planet1, planet2, 42, dgmpp::SchematicID::electrolytes);
	route(planet1, planet2, 10, 42, TypeID::ionicSolutions);
	route(planet1, planet2, 42, 10, TypeID::electrolytes);

	setSchematic(planet1, planet2, 43, dgmpp::SchematicID::oxygen);
	route(planet1, planet2, 10, 43, TypeID::nobleGas);
	route(planet1, planet2, 43, 10, TypeID::oxygen);

	setSchematic(planet1, planet2, 44, dgmpp::SchematicID::plasmoids);
	route(planet1, planet2, 10, 44, TypeID::suspendedPlasma);
	route(planet1, planet2, 44, 10, TypeID::plasmoids);

	setSchematic(planet1, planet2, 45, dgmpp::SchematicID::water);
	route(planet1, planet2, 10, 45, TypeID::aqueousLiquids);
	route(planet1, planet2, 45, 10, TypeID::water);

	
	route(planet1, planet2, 20, 10, TypeID::baseMetals);
	route(planet1, planet2, 21, 10, TypeID::microorganisms);
	route(planet1, planet2, 22, 10, TypeID::complexOrganisms);
	route(planet1, planet2, 23, 10, TypeID::carbonCompounds);
	route(planet1, planet2, 24, 10, TypeID::autotrophs);
	route(planet1, planet2, 25, 10, TypeID::ionicSolutions);
	route(planet1, planet2, 26, 10, TypeID::nobleGas);
	route(planet1, planet2, 27, 10, TypeID::suspendedPlasma);
	route(planet1, planet2, 28, 10, TypeID::aqueousLiquids);
	
	auto e1 = planet1->simulate();
	auto e2 = planet2.run();
	
	auto s1 = planet1->findFacility(10).get();
	auto s2 = planet2[10];
	
	auto raw = 	{TypeID::baseMetals,
	TypeID::microorganisms,
	TypeID::complexOrganisms,
	TypeID::carbonCompounds,
	TypeID::autotrophs,
	TypeID::ionicSolutions,
	TypeID::nobleGas,
	TypeID::suspendedPlasma,
		TypeID::aqueousLiquids};

	
	size_t sum1 = 0;
	for (auto i: s1->getCommodities()) {
		if (i.getQuantity() > 0)
			std::cout << (int)i.getTypeID() << ": " << i.getQuantity() << " ";
		sum1 += i.getQuantity();
	}
	std::cout << std::endl;
	size_t sum2 = 0;
	for (auto i: s2->commodities()) {
		if (i.quantity() > 0)
			std::cout << (int)i.metaInfo().typeID << ": " << i.quantity() << " ";
		sum2 += i.quantity();
	}
	
//	sum1 = sum2 = 0;
//	for (auto i: raw) {
//		auto a = s1->getIncomming(dgmpp::Commodity(planet1->getEngine(), i)).getQuantity();
//		auto b = s2->income(i).quantity();
//		sum1 += a;
//		sum2 += b;
//		if (a != b)
//			std::cout << a - b << " ";
//	}
	
	std::cout << std::endl;
	for (auto i: planet1->getFacilities())
		std::cout << i->getIdentifier() << " ";
	std::cout << std::endl;
	
	
	for (auto i: planet2.facilities())
		std::cout << i->identifier() << " ";
	std::cout << std::endl;

	std::cout << sum1 << " " << sum2 << std::endl;

}

template <typename T>
constexpr T sum(T first) {
	return first;
}


template <typename T, typename... Tail>
constexpr T sum(T first, Tail... args) {
	return first + sum(args...);
}

template<typename T, typename... Tail>
constexpr double percentage(T first, Tail... args) {
	auto s = sum(first, args...);
	return s > 0 ? first / s : 0;
}




int main(int argc, const char * argv[]) {
	@autoreleasepool {
		
		std::list<std::vector<int>> prev;
		for (int i = 0; i < 10; i++) {
			std::unordered_set<int> set;
			for (int j = 0; j < 100; j++) {
				set.insert(j);
			}
			std::vector<int> v;
			std::copy(set.begin(), set.end(), std::back_inserter(v));
			auto b = std::all_of(prev.begin(), prev.end(), [&](const auto& i) {
//				return std::equal(i.begin(), i.end(), v.begin());
				return i == v;
			});
			assert(b);
			prev.push_back(std::move(v));
		}

		auto t0 = std::chrono::high_resolution_clock::now();
		{
			constexpr auto s = dgmpp2::percentage(10, 40);
			
			std::unordered_set<std::tuple<int, int>> set;
			set.emplace(1,2);
//			auto t = std::make_tuple(1,2);
//			auto h = std::hash<decltype(t)>()(t);
//			std::cout << std::hash<decltype(t)>()(t) << std::endl;
//			std::cout << hash_combine_v(hash_combine_v(0, 2), 1) << std::endl;
//			std::cout << hash(1,&t) << std::endl;
		
			auto gang = dgmpp2::Gang::Create();
			auto pilotA = gang->add(dgmpp2::Character::Create());
			pilotA->setSkillLevels(5);
			auto shipA = pilotA->setShip(dgmpp2::Ship::Create(TypeID::dominix));
			shipA->add(dgmpp2::Module::Create(TypeID::largeArmorRepairerI));
			
//			auto ehp0 = shipA->effectiveHitPoints();
			
			auto pilotB = gang->add(dgmpp2::Character::Create());
			pilotB->setSkillLevels(5);
			auto shipB = pilotB->setShip(dgmpp2::Ship::Create(TypeID::erebus));
//			shipB->add(dgmpp2::Module::Create(TypeID::gallentePhenomenaGenerator));
			
//			auto ehp1 = shipA->effectiveHitPoints();
			
			shipB->add(dgmpp2::Module::Create(TypeID::shieldCommandBurstI))->charge(dgmpp2::Charge::Create(TypeID::shieldHarmonizingCharge));
			
			auto ehp2 = shipA->effectiveHitPoints();
			
		}
		auto t1 = std::chrono::high_resolution_clock::now();
		{
			std::shared_ptr<Engine> engine = std::make_shared<Engine>(std::make_shared<SqliteConnector>("/Users/shimanski/Documents/git/EVEUniverse/ThirdParty/dgmpp/dbinit/dgm.sqlite"));
			testPI3(engine);
			return 1;
			
			testPI(engine);
			testPI2();
			
			auto pilot = engine->getGang()->addPilot();
			pilot->setAllSkillsLevel(5);
			auto ship = pilot->setShip(dgmpp::TypeID::dominix);
			
			auto total = [](dgmpp::HitPoints ehp) {
				return ehp.shield + ehp.armor + ehp.hull;
			};

			std::cout << total(ship->getEffectiveHitPoints()) << std::endl;
			
			auto pilot2 = engine->getGang()->addPilot();
			pilot2->setAllSkillsLevel(5);
			auto erebus = pilot->setShip(dgmpp::TypeID::erebus);
			auto pg = erebus->addModule(TypeID::gallentePhenomenaGenerator);
			std::cout << total(ship->getEffectiveHitPoints()) << std::endl;
			pg->setState(dgmpp::Module::State::offline);
			std::cout << total(ship->getEffectiveHitPoints()) << std::endl;

		}
		auto t2 = std::chrono::high_resolution_clock::now();
		auto dt0 = t1-t0;
		auto dt1 = t2-t1;
		std::cout << dt0.count() << " " << dt1.count() << std::endl << (double)dt1.count() / (double)dt0.count() << std::endl;
		return 0;
//		578=2
//		37=218
//
//		578=2.34775
//		37=255.905
		
		
		return 0;
//		auto result = engine->getSqlConnector()->fetch<int, std::string>("select typeID, typeName from invTypes");
//
//		auto typeName = std::get<1>(result);
		
//		std::shared_ptr<Engine> engine = std::make_shared<Engine>(std::make_shared<SqliteConnector>("/Users/shimanski/work/git/EVEUniverse/ThirdParty/dgmpp/dbinit/dgm.sqlite"));
		std::shared_ptr<Engine> engine = std::make_shared<Engine>(std::make_shared<SqliteConnector>("/Users/shimanski/Documents/git/EVEUniverse/ThirdParty/dgmpp/dbinit/dgm.sqlite"));
		auto pilot = engine->getGang()->addPilot();
		pilot->setAllSkillsLevel(5);
		
/*
		//pilot->setAllSkillsLevel(5);
		std::map<int, int> skills;
		skills[32339] = 5;
		pilot->setSkillLevels(skills);
		
		auto spaceStructure = pilot->setStructure(35832);
 
		std::shared_ptr<Drone> drone;
		for (int i = 0; i < 30; i++) {
			drone = spaceStructure->addDrone(40365);
		}
		int heavy = spaceStructure->getDroneSquadronUsed(Drone::FIGHTER_SQUADRON_HEAVY);
		int light = spaceStructure->getDroneSquadronUsed(Drone::FIGHTER_SQUADRON_LIGHT);
		float v = drone->getAttribute(2226)->getValue();
		
		double lastUpdateTime = 1452068276;
		auto planet = engine->setPlanet(2016);
		planet->setLastUpdate(lastUpdateTime - lastUpdateTime);
		planet->addFacility(2524, 1019338918550);
		planet->addFacility(2541, 1019339001861);
		planet->addFacility(2474, 1019339001862);
		planet->addFacility(2544, 1019339001863);
		planet->addFacility(2474, 1019339001865);
		planet->addFacility(2473, 1019339001870);
		planet->addFacility(2473, 1019339001873);
		planet->addFacility(2473, 1019339001877);
		planet->addFacility(2848, 1019339001881);
		planet->addFacility(2473, 1019339001884);
		planet->addFacility(2473, 1019339001885);
		planet->addFacility(2473, 1019339001888);
		planet->addFacility(2474, 1019586416755);
		planet->addFacility(2848, 1019741064685);
		
		planet->addRoute(planet->findFacility(1019339001861), planet->findFacility(1019339001877), Commodity(engine, 2270, 0));
		planet->addRoute(planet->findFacility(1019339001861), planet->findFacility(1019339001873), Commodity(engine, 2270, 0));
		planet->addRoute(planet->findFacility(1019339001861), planet->findFacility(1019339001870), Commodity(engine, 2270, 0));
		planet->addRoute(planet->findFacility(1019339001861), planet->findFacility(1019339001865), Commodity(engine, 2399, 0));
		planet->addRoute(planet->findFacility(1019339001861), planet->findFacility(1019339001862), Commodity(engine, 2399, 0));
		planet->addRoute(planet->findFacility(1019339001861), planet->findFacility(1019586416755), Commodity(engine, 2399, 0));
		planet->addRoute(planet->findFacility(1019339001861), planet->findFacility(1019586416755), Commodity(engine, 2399, 0));
		
		planet->addRoute(planet->findFacility(1019339001862), planet->findFacility(1019339001863), Commodity(engine, 3689, 0));
		planet->addRoute(planet->findFacility(1019339001865), planet->findFacility(1019339001863), Commodity(engine, 2329, 0));
		planet->addRoute(planet->findFacility(1019339001870), planet->findFacility(1019339001861), Commodity(engine, 2399, 0));
		planet->addRoute(planet->findFacility(1019339001873), planet->findFacility(1019339001861), Commodity(engine, 2399, 0));
		planet->addRoute(planet->findFacility(1019339001877), planet->findFacility(1019339001861), Commodity(engine, 2399, 0));
		planet->addRoute(planet->findFacility(1019339001881), planet->findFacility(1019339001861), Commodity(engine, 2270, 0));
		planet->addRoute(planet->findFacility(1019339001884), planet->findFacility(1019339001861), Commodity(engine, 2396, 0));
		planet->addRoute(planet->findFacility(1019339001885), planet->findFacility(1019339001861), Commodity(engine, 2396, 0));
		planet->addRoute(planet->findFacility(1019339001888), planet->findFacility(1019339001861), Commodity(engine, 2396, 0));
		planet->addRoute(planet->findFacility(1019586416755), planet->findFacility(1019339001863), Commodity(engine, 2329, 0));
		planet->addRoute(planet->findFacility(1019741064685), planet->findFacility(1019339001861), Commodity(engine, 2288, 0));
		
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001862))->setSchematic(73);
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001865))->setSchematic(79);
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001870))->setSchematic(127);
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001873))->setSchematic(127);
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001877))->setSchematic(127);
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001884))->setSchematic(134);
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001885))->setSchematic(134);
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001888))->setSchematic(134);
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019586416755))->setSchematic(79);

		std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019339001881))->setCycleTime(120 * 60);
		std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019339001881))->setQuantityPerCycle(4741);
		std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019339001881))->setLaunchTime(1452068276 - lastUpdateTime);
		std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019339001881))->setInstallTime(1452068276 - lastUpdateTime);
		std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019339001881))->setExpiryTime(1452500276 - lastUpdateTime);
		
		std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019741064685))->setCycleTime(120 * 60);
		std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019741064685))->setQuantityPerCycle(6425);
		std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019741064685))->setLaunchTime(1452068276 - lastUpdateTime);
		std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019741064685))->setInstallTime(1452068276 - lastUpdateTime);
		std::dynamic_pointer_cast<ExtractorControlUnit>(planet->findFacility(1019741064685))->setExpiryTime(1452500276 - lastUpdateTime);

		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019586416755))->setLaunchTime(0);
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001865))->setLaunchTime(0);
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001870))->setLaunchTime(0);
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001873))->setLaunchTime(0);
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001877))->setLaunchTime(0);
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001884))->setLaunchTime(0);
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001885))->setLaunchTime(0);
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019339001888))->setLaunchTime(0);
		std::dynamic_pointer_cast<IndustryFacility>(planet->findFacility(1019586416755))->setLaunchTime(0);

		double endTime = planet->simulate();
		

		auto fac = planet->findFacility(1019339001865);
		
		//std::cout << *planet << std::endl;
		auto free = fac->getFreeVolume();
		return 0;
*/
		
		
		auto eos = pilot->setShip(TypeID::eos);
		auto armorRepairer = eos->addModule(TypeID::largeArmorRepairerI);
		
		auto before = eos->getEffectiveTank().armorRepair;
		
		auto armorCommandBurst = eos->addModule(TypeID::armorCommandBurstI);
//		armorCommandBurst->setCharge(42832); //Armor Energizing Charge
		armorCommandBurst->setCharge(TypeID(42833)); //Rapid Repair Charge
		armorCommandBurst->setState(dgmpp::Module::State::active);
		auto after = eos->getEffectiveTank().armorRepair;
		
		
		
		NSString* garmurDNA = @"33816:2404;3:14248;1:1952;1:19349;1:28746;1:31936;1:2605;1:2048;1:31183;1:31153;1:31111;1:29009;1:27371;3::";
		NSString* ishkurDNA = @"12042:3178;3:5973;1:448;1:4025;1:1183;1:1447;1:10190;1:2048;1:31538;1:31526;1:2456;5:12612;3::";
		NSString* vigilantDNA = @"17722:3146;5:5439;1:4025;1:6160;1:5975;1:10190;3:4405;2:2048;1:31546;1:31055;1:2185;5:12789;5:29011;1::";
		//NSString* vigilantDNA = @"17722:3146;5:5439;1:4025;1:10850;1:5975;1:3530;1:4405;2:10190;3:31546;1:31055;1:2185;5:12789;5::";
		NSString* magusDNA = @"37483:4284;1:4282;1:4280;1:11014;2::";
		//NSString* morosDNA = @"19724:4292;1::";
		NSString* dramielDNA = @"17932:34595;1:12084;1::";
		
		auto garmur = addShip(engine, garmurDNA);
		auto ishkur = addShip(engine, ishkurDNA);
		auto vigilant = addShip(engine, vigilantDNA);
		auto dramiel = addShip(engine, dramielDNA);
//		auto magus1 = addShip(engine, magusDNA, 1);
//		auto magus5 = addShip(engine, magusDNA, 5);
		
		
/*		Tank tankOff = vigilant->getTank();
		HitPoints hpOff = vigilant->getHitPoints();
		float capOff = vigilant->getCapUsed();
		engine->getGang()->setFleetBooster(std::dynamic_pointer_cast<Character>(magus1->getOwner()));
		Tank tank1 = vigilant->getSustainableTank();
		HitPoints hp1 = vigilant->getHitPoints();
		float cap1 = vigilant->getCapUsed();
		engine->getGang()->setFleetBooster(std::dynamic_pointer_cast<Character>(magus5->getOwner()));
		Tank tank5 = vigilant->getSustainableTank();
		HitPoints hp5 = vigilant->getHitPoints();
		float cap5 = vigilant->getCapUsed();
		engine->getGang()->setSquadBooster(std::dynamic_pointer_cast<Character>(magus1->getOwner()));
		Tank tank15 = vigilant->getSustainableTank();
		HitPoints hp15 = vigilant->getHitPoints();
		float cap15 = vigilant->getCapUsed();*/
		
/*		std::ofstream os;
		os.open("/Users/shimanski/tmp/gang.json");
		os << *engine->getGang() << std::endl;
		os.close();*/
		return 0;
		auto velocity = dramiel->getVelocity();
		auto hp = vigilant->getHitPoints();
		float dps = vigilant->getWeaponDps();
		
		for (int j = 0; j < 5; j++) {
			CFTimeInterval t0 = CACurrentMediaTime();
			CombatSimulator simulator(garmur, ishkur);
			CombatSimulator::OrbitState state(garmur, ishkur, 0, 5000);
			int n = 300;
			float dx = 50000 / n;
			float x = dx;
			for (int i = 0; i < n; i++) {
				state.setOrbitRadius(x);
				simulator.setState(state);
				simulator.timeToDie();
				simulator.timeToKill();
				x += dx;
			}
		}
	}
    return 0;
}

/*

 2015-12-14 13:20:07.863 dgmppDemo[7185:846124] load 0.321260
 2015-12-14 13:20:08.490 dgmppDemo[7185:846124] 0.613162
 2015-12-14 13:20:09.085 dgmppDemo[7185:846124] 0.595061
 2015-12-14 13:20:09.679 dgmppDemo[7185:846124] 0.593356
 2015-12-14 13:20:10.267 dgmppDemo[7185:846124] 0.587562
 2015-12-14 13:20:10.849 dgmppDemo[7185:846124] 0.581632
 Program ended with exit code: 0
*/
