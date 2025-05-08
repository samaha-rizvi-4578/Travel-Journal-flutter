import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:travel_journel/home/presentation/pages/home_page.dart';

class MockAuthBloc extends Mock implements BlocBase<dynamic> {}

class MockAuthState {
  final dynamic user;
  MockAuthState({this.user});
}

class FakeUser {
  final String? email;
  FakeUser(this.email);
}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<BlocBase<dynamic>>.value(
        value: mockAuthBloc,
        child: const HomePage(),
      ),
    );
  }

  testWidgets('HomePage shows welcome text', (WidgetTester tester) async {
    when(() => mockAuthBloc.state).thenReturn(MockAuthState(user: FakeUser('test@example.com')));

    await tester.pumpWidget(createTestWidget());

    expect(find.text('Welcome, test@example.com!'), findsOneWidget);
  });
}