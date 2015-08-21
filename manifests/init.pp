# Class: win_notepadplusplus
#
# This module manages the installation of Notepad++ on Windows nodes
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class win_notepadplusplus (
  $p_software_repo     = $global_software_repo_path,
  $p_install_path = undef,
  $p_notepad_version = '6.8.1',
  $p_notepad_installer = 'npp.6.8.1.Installer.exe',) {
  # validate parameters

  # Location of the installer files must be known.
  if $p_software_repo == undef {
    warning('software_repo must be set. Either set parameter $p_software_repo or create a global variable $global_software_repo_path.'
    )
  } else {
    if $::osfamily == 'Windows' {
      # Use the default install path if no $install_path is provided.
      if $p_install_path == undef {
        if $::architecture == 'x64' {
          $install_path = 'C:\Program Files (x86)\Notepad++'
        } else {
          $install_path = 'C:\Program Files\Notepad++'
        }
      } else {
        $install_path = $p_install_path
      }

      package { 'Notepad++':
        ensure          => $p_notepad_version,
        source          => "${p_software_repo}\\${p_notepad_installer}",
        install_options => ['/S', "/D=${install_path}"],
      }

      # remove the updater folder to disable updates for this application
      file { 'remove auto-update feature':
        ensure  => absent,
        recurse => true,
        force   => true,
        path    => "${install_path}/updater",
        require => Package['Notepad++'],
      }
    } else {
      warning('This Notepad++ module does only work on Windows machines')
    }
  }
}
