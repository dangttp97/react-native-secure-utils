import { useState, useEffect } from 'react';
import { StyleSheet, View, Text } from 'react-native';
import SecurityCore from '../../src/index';

export default function App() {
  const [result, setResult] = useState<boolean | undefined>();

  useEffect(() => {
    const checkIntegrity = async () => {
      const deviceIntegrity = await SecurityCore.detectFridaFiles();
      console.log(deviceIntegrity);
      setResult(!deviceIntegrity);
    };
    checkIntegrity();
  }, []);

  return (
    <View style={styles.container}>
      <Text>Integrity: {result ? 'OK' : 'NG'}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
