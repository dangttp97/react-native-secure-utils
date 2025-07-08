import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-security-core' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const SecurityCore = NativeModules.SecurityCore
  ? NativeModules.SecurityCore
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export interface SecurityCoreInterface {
  // ========== Android Security Functions ==========
  runAdvancedChecks(): Promise<boolean>;
  detectDebugger(): Promise<boolean>;
  detectFridaThread(): Promise<boolean>;
  detectMemoryMaps(): Promise<boolean>;
  checkProcessName(): Promise<boolean>;
  verifyIntegrity(): Promise<boolean>;

  // ========== iOS Security Functions ==========
  runIOSAntiFrida(): Promise<boolean>;
  runIOSSecurityChecks(): Promise<boolean>;
  detectFridaLibraries(): Promise<boolean>;
  detectFridaEnv(): Promise<boolean>;
  detectFridaFiles(): Promise<boolean>;
  detectFridaSymbols(): Promise<boolean>;
  detectCodeInjection(): Promise<boolean>;

  // ========== Utility Functions ==========
  xorDecode(encoded: string, key: number): Promise<string>;
  crc32(data: number[]): Promise<number>;

  // ========== Unified Root/Jailbreak Detection ==========
  isRooted(): Promise<boolean>;
}

export default SecurityCore as SecurityCoreInterface & {
  isRooted: () => Promise<boolean>;
};

// ========== Platform-specific helpers ==========

export class SecurityCoreHelper {
  private static instance: SecurityCoreInterface = SecurityCore;

  // ========== Android Security ==========
  static async checkAndroidSecurity(): Promise<boolean> {
    try {
      return await this.instance.runAdvancedChecks();
    } catch (error) {
      console.error('Android security check failed:', error);
      return false;
    }
  }

  static async checkAndroidDebugger(): Promise<boolean> {
    try {
      return await this.instance.detectDebugger();
    } catch (error) {
      console.error('Android debugger detection failed:', error);
      return false;
    }
  }

  static async checkAndroidFrida(): Promise<boolean> {
    try {
      return await this.instance.detectFridaThread();
    } catch (error) {
      console.error('Android Frida detection failed:', error);
      return false;
    }
  }

  // ========== iOS Security ==========
  static async checkIOSSecurity(): Promise<boolean> {
    try {
      const fridaClean = await this.instance.runIOSAntiFrida();
      const iosSecure = await this.instance.runIOSSecurityChecks();
      return fridaClean && iosSecure;
    } catch (error) {
      console.error('iOS security check failed:', error);
      return false;
    }
  }

  static async checkIOSFrida(): Promise<boolean> {
    try {
      return await this.instance.runIOSAntiFrida();
    } catch (error) {
      console.error('iOS Frida detection failed:', error);
      return false;
    }
  }

  static async checkIOSJailbreak(): Promise<boolean> {
    try {
      return await this.instance.runIOSSecurityChecks();
    } catch (error) {
      console.error('iOS jailbreak detection failed:', error);
      return false;
    }
  }

  // ========== Cross-platform Security ==========
  static async checkAllSecurity(): Promise<{
    android: boolean;
    ios: boolean;
    overall: boolean;
  }> {
    try {
      const androidSecure = await this.checkAndroidSecurity();
      const iosSecure = await this.checkIOSSecurity();

      return {
        android: androidSecure,
        ios: iosSecure,
        overall: androidSecure && iosSecure,
      };
    } catch (error) {
      console.error('Security check failed:', error);
      return {
        android: false,
        ios: false,
        overall: false,
      };
    }
  }

  // ========== Utility Functions ==========
  static async decodeString(encoded: string, key: number): Promise<string> {
    try {
      return await this.instance.xorDecode(encoded, key);
    } catch (error) {
      console.error('String decode failed:', error);
      return '';
    }
  }

  static async calculateCRC32(data: number[]): Promise<number> {
    try {
      return await this.instance.crc32(data);
    } catch (error) {
      console.error('CRC32 calculation failed:', error);
      return 0;
    }
  }

  // ========== Unified Root/Jailbreak ==========
  static async isRooted(): Promise<boolean> {
    try {
      return await this.instance.isRooted();
    } catch (error) {
      console.error('Root/jailbreak detection failed:', error);
      return false;
    }
  }
}

// ========== Export everything ==========
