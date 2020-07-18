import { NativeModules } from 'react-native';

type AddQrcodeType = {
  multiply(a: number, b: number): Promise<number>;
};

const { AddQrcode } = NativeModules;

export default AddQrcode as AddQrcodeType;
