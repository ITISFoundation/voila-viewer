## Voilà Viewer
Source code of the correspondng o²S²PARC Service that takes as input a Jupyter Notebook and it shows it using Jupyter [Voilà](https://github.com/voila-dashboards/voila)

## How it works
The Service waits for a `voila.ipynb` file in input_1, when it is found, in renders it with voila:


![Voila_Viewer_v1](https://github.com/ITISFoundation/voila-viewer/assets/18575092/73d43e27-71d8-4733-bf20-32262a2e9824)

## How to test

### Locally

```
make build run-local # Then visit 127.0.0.1:8888 in your browser
```
A `voila.ipynb` has to be `added to validation/inputs/input_1`
### In a local o²S²PARC deployment

```
make build publish-local
```

### In o²S²PARC
Use the "Voila-viewer Example" template in master.
