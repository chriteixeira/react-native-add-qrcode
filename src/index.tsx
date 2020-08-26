import { NativeModules } from 'react-native';
import path from 'path';
import { processColor } from 'react-native';

type AddQRCodeToImageOptions = {
  x?: number;
  y?: number;
  height?: number;
  width?: number;
  quality?: number;
  backgroundColor?: string;
  foregroundColor?: string;
};

export function addQRCodeToImage(
  imagePath: string,
  destinationPath: string,
  data: string,
  options?: AddQRCodeToImageOptions
) {
  if (!imagePath) {
    throw new Error('Missing parameter imagePath.');
  }
  if (!imagePath) {
    throw new Error('Missing parameter data.');
  }
  if (!destinationPath) {
    throw new Error('Missing parameter destinationPath.');
  }

  const ext = path.extname(imagePath);
  if (ext !== '.jpg' && ext !== 'jpeg') {
    throw new Error(
      'You must provide a path to a Jpeg image. Other formats are not supported yet.'
    );
  }

  const opts: AddQRCodeToImageOptions = options || {};
  return NativeModules.AddQrcode.addQRCodeToImage(
    imagePath,
    destinationPath,
    data,
    {
      x: opts.x || 0,
      y: opts.y || 0,
      height: opts.height || 250,
      width: opts.width || 250,
      quality: opts.quality || 1.0,
      backgroundColor: processColor(opts.backgroundColor || '#FFFFFF'),
      foregroundColor: processColor(opts.foregroundColor || '#000000'),
    }
  );
}
