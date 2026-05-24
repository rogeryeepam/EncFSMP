/**
 * EncFSMP Command Line Tool
 * Minimal CLI for mounting encfs volumes without GUI
 */

#include <iostream>
#include <string>
#include <memory>

// libencfs
#include "encfs/Interface.h"
#include "encfs/Context.h"
#include "encfs/CipherKey.h"

// PFM Layer
#include "pfm_layer.h"

int main(int argc, char* argv[])
{
    if (argc < 4) {
        std::cerr << "Usage: encfsmp-cli <encrypted_dir> <mount_point> <password>" << std::endl;
        std::cerr << "Example: encfsmp-cli C:\\encrypted D:\\mount mypassword" << std::endl;
        return 1;
    }

    std::string cipherDir = argv[1];
    std::string mountPoint = argv[2];
    std::string password = argv[3];

    std::cout << "Mounting encfs volume: " << cipherDir << " -> " << mountPoint << std::endl;

    try {
        // Initialize encfs context
        encfs::Context context;
        
        // Load the encrypted filesystem
        encfs::RootPtr rootFS = encfs::loadEncFS(
            cipherDir, 
            password, 
            &context,
            false  // not a reverse mount
        );

        if (!rootFS) {
            std::cerr << "Failed to load encfs volume" << std::endl;
            return 1;
        }

        std::cout << "EncFS volume loaded successfully" << std::endl;

        // Create PFM layer and mount
        PFMLayer pfmLayer;
        
        // Convert mountPoint to wide string
        std::wstring mountPointW(mountPoint.begin(), mountPoint.end());
        
        // Get PFM API
        PfmApi* pfmApi = PfmGetApi();
        if (!pfmApi) {
            std::cerr << "Failed to get PFM API" << std::endl;
            return 1;
        }

        std::cout << "Mounting..." << std::endl;
        
        // Start the filesystem (this will block until unmount)
        pfmLayer.startFS(
            rootFS,
            mountPointW.c_str(),
            pfmApi,
            L'-',          // driveLetter: '-' means auto-assign
            true,          // useCaching
            true,          // worldWrite
            false,         // localDrive
            false,         // startBrowser
            std::cout      // output stream
        );

        std::cout << "Unmounted successfully" << std::endl;
        
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }

    return 0;
}