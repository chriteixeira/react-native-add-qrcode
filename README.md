# react-native-add-qrcode

Add a QRCode to a image.

This libs just supports JPEG images at this moment. We might add other types support if necessary.

## Installation

```sh
npm install react-native-add-qrcode
```

## Usage

```js
import { addQRCodeToImage } from 'react-native-add-qrcode';

// ...

const result = await addQRCodeToImage('path/to/image', 
                                      'path/to/result/image',
                                      'QR Code Data',
                                      {
                                        x: 10, 
                                        y: 10, 
                                        height: 250,
                                        width: 250,
                                        foregroundColor: '#FFFFFF',
                                        backgroundColor: '#000000'
                                      }
                                    );
```

## API

**Signature:**
```js
static addQRCodeToImage(imagePath: string, destinationPath: string, data: string, options?: OptionsType): Promise<ResultType>

type OptionsType = {
  x?: number;                   // Horizontal position of the QR Code
  y?: number;                   // Vertical position of the QR Code
  height?: number;              // Height of the QR Code
  width?: number;               // Width of the QR Code
  backgroundColor?: string;     // Color for the background of the QR Code
  foregroundColor?: string;     // Color for the foreground of the QR Code
}

type ResultType = {
  uri: string;          // URI for the final image
  finalWidth: number,   // QR code final width
  finalHeight: number   // QR code final height
}

```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
