from onnx_coreml import convert
PATH = './JScifar_net'
def tomodel():
    class_labels = ['air plane', 'automobile', 'bird', 'cat', 'deer', 'dog',
                    'frog', 'horse', 'ship', 'truck']
    model = convert(model=PATH + '.onnx',
                    minimum_ios_deployment_target='13', image_input_names=['image'],
                    mode='classifier',
                    predicted_feature_name='classLabel',
                    class_labels=class_labels)
    model.save(PATH + '.mlmodel')


if __name__ == '__main__':
    tomodel()
