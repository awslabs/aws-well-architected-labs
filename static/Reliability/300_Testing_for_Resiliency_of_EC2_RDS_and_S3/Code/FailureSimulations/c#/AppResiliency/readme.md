## Installation Instructions
Download the package

```
aws s3 cp s3://bucket/csharpresiliency.zip ~/temp.zip
```

Unzip it

```
unzip ~/temp.zip
```

Change directory to the appropriate platform

**Linux x64**
```bash
cd ~/linux-x64
```

**Linux ARM64**
```bash
cd ~/linux-arm64
```

**Windows 10 and Server 2016 x64**
```cmd
cd ~/win10-x64
```

**MacOS x64**
```bash
cd ~/osx-x64
```

For Linux and MacOS, make the file executable

```bash
chmod +x AppResiliency
```

For Linux ARM64, execute this

```bash
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
```

On Linux and MacOS, execute the file like this

```bash
./AppResiliency args
```

On Windows
```cmd
AppResiliency.exe args
```