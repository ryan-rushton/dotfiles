const tsEslint = require('@typescript-eslint/eslint-plugin')
const tsParser = require('@typescript-eslint/parser')
const importPlugin = require('eslint-plugin-import')
const nPlugin = require('eslint-plugin-n')
const promisePlugin = require('eslint-plugin-promise')
const prettierConfig = require('eslint-config-prettier')
const globals = require('globals')

module.exports = [
  {
    files: ['**/*.{js,mjs,cjs,ts}'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      parser: tsParser,
      parserOptions: {
        project: './tsconfig.json'
      },
      globals: {
        ...globals.node
      }
    },
    plugins: {
      '@typescript-eslint': tsEslint,
      import: importPlugin,
      n: nPlugin,
      promise: promisePlugin
    },
    rules: {
      // Custom overrides first
      '@typescript-eslint/explicit-function-return-type': 'off',
      '@typescript-eslint/no-floating-promises': 'off',
      '@typescript-eslint/strict-boolean-expressions': 'off',
      '@typescript-eslint/no-unsafe-assignment': 'off',
      '@typescript-eslint/no-unsafe-member-access': 'off',
      '@typescript-eslint/require-await': 'off',
      
      // Standard rules
      'no-var': 'error',
      'prefer-const': 'error',
      'no-unused-vars': 'off',
      '@typescript-eslint/no-unused-vars': [
        'error',
        {
          varsIgnorePattern: '^(_|ignored|)',
          argsIgnorePattern: '^(_|ignored)',
          caughtErrorsIgnorePattern: '^(_|ignored)',
        },
      ],
      'no-undef': 'off',
      eqeqeq: 'error',
      curly: 'error',
      'no-console': 'off',
      
      // Import/module resolution rules
      'import/no-unresolved': 'off',
      'n/no-missing-import': 'off'
    }
  },
  {
    ignores: ['node_modules/', 'target/', 'eslint.config.js']
  },
  prettierConfig
]