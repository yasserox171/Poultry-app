import React, { useEffect } from 'react';
import { I18nManager, LogBox } from 'react-native';
import { StatusBar } from 'expo-status-bar';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import AppNavigator from './src/navigation/AppNavigator';

// Force RTL for Arabic
I18nManager.forceRTL(true);

// Suppress minor warnings from libraries
LogBox.ignoreLogs([
  'Warning: componentWillReceiveProps',
  'Warning: componentWillMount',
  'Non-serializable values were found in the navigation state',
]);

export default function App() {
  return (
    <SafeAreaProvider>
      <StatusBar style="light" />
      <AppNavigator />
    </SafeAreaProvider>
  );
}
