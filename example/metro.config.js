const path = require('path');
const { getDefaultConfig } = require('@react-native/metro-config');

/**
 * Metro configuration
 * https://facebook.github.io/metro/docs/configuration
 *
 * @type {import('metro-config').MetroConfig}
 */

module.exports = {
  ...getDefaultConfig(__dirname),
  watchFolders: [path.resolve(__dirname, '..')],
  resolver: {
    extraNodeModules: {
      'react-native-security-core': path.resolve(__dirname, '..'),
    },
  },
};
