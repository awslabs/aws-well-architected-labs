dotnet restore

dotnet publish --configuration Release --framework netcoreapp3.1 --runtime linux-x64 --output ./output/linux-x64 --self-contained true -p:PublishSingleFile=true
dotnet publish --configuration Release --framework netcoreapp3.1 --runtime win10-x64 --output ./output/win10-x64 --self-contained true -p:PublishSingleFile=true
dotnet publish --configuration Release --framework netcoreapp3.1 --runtime osx-x64 --output ./output/osx-x64 --self-contained true -p:PublishSingleFile=true

Compress-Archive -Path ./output/* -DestinationPath "csharpresiliency.zip" -Force