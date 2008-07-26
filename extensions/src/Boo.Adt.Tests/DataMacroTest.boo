namespace Boo.Adt.Tests

import NUnit.Framework
import Boo.Adt

data Expression = Const(value as int) \
			| Add(left as Expression, right as Expression)
			
data ExpressionX < Expression = Mult(left as Expression, right as Expression)

data Result(Value as int) = Success() | Failure(Error as string)

data Foo(Value as int)

[TestFixture]
class DataMacroTest:
	
	[Test]
	def TestSingleType():
		type = Foo
		assert object is type.BaseType
		Assert.AreEqual("Foo(42)", Foo(42).ToString())

	[Test]
	def TestBaseFields():
		Assert.AreEqual("Success(42)", Success(42).ToString())
		Assert.AreEqual("Failure(42, crash)", Failure(42, "crash").ToString())
		Assert.AreEqual(Success(42), Success(42))
		Assert.IsFalse(Success(42) == Success(21))

	[Test]
	def TestClassHierarchy():
		type = Expression
		assert type.IsAbstract
		
		for type in Const, Add:
			assert not type.IsAbstract
			assert not type.IsSealed
			assert Expression is type.BaseType
			
		assert Expression is typeof(ExpressionX).BaseType
		assert ExpressionX is typeof(Mult).BaseType
			
	[Test]
	def TestToString():
		Assert.AreEqual("Const(42)", Const(42).ToString())
		Assert.AreEqual("Add(Const(19), Const(22))", Add(Const(19), Const(22)).ToString())
		
	[Test]
	def TestEquals():
		Assert.AreEqual(Const(42), Const(42))
		assert Const(-1) != Const(42)
		
	[Test]
	def TestProperties():
		Assert.AreEqual(42, Const(42).value)