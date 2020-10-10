### Install Dependencies

```
$ pip3 install numpy scipy matplotlib ipython scikit-learn pandas torch torchvision nltk
```


### Check the GPU

```py
import torch

print(torch.cuda.is_available())
print(torch.cuda.device_count())
print(torch.cuda.current_device())
print(torch.cuda.device(0))
print(torch.cuda.get_device_name(0))
```