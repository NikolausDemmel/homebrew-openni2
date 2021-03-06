require 'formula'

class Openni2Freenectdriver < Formula
  homepage 'https://github.com/piedar/OpenNI2-FreenectDriver'
  url 'https://github.com/piedar/OpenNI2-FreenectDriver.git', :revision => 'ee732fd66f83300cad6cfc71b4dcfc2427024b98'
  version '1.2.1'
  sha1 'ee732fd66f83300cad6cfc71b4dcfc2427024b98'
  head 'https://github.com/piedar/OpenNI2-FreenectDriver.git'

  option :universal

  depends_on :python
  depends_on 'openni2' => (build.universal?) ? ['universal'] : []
  depends_on 'libfreenect' => (build.universal?) ? ['universal'] : []

  def install
    inreplace 'wscript', 'extern/OpenNI-Linux-x64-2.2.0.33/Include', "#{HOMEBREW_PREFIX}/include/ni2"
    inreplace 'wscript', '/usr/local/include/libfreenect', "#{HOMEBREW_PREFIX}/include/libfreenect"

    if build.universal?
        inreplace 'wscript', "conf.env.CXXFLAGS = ['-O2'] #+ strict", "conf.env.CXXFLAGS = ['-O2'] #+ strict\n\tconf.env.append_value('CXXFLAGS', ['-arch', 'i386'])\n\tconf.env.append_value('CXXFLAGS', ['-arch', 'x86_64'])\n\tconf.env.append_value('LINKFLAGS', ['-arch', 'i386'])\n\tconf.env.append_value('LINKFLAGS', ['-arch', 'x86_64'])"
    end

    system 'python', 'waf', 'configure', 'build'

    driver = 'libFreenectDriver.dylib'
    prefix.install 'build/' + driver

    src = "#{prefix}/" + driver
    openni2_cellar = Dir.glob("#{HOMEBREW_PREFIX}/Cellar/openni2/*")[0]
    ln_s src, openni2_cellar + '/lib/ni2/OpenNI2/Drivers/' + driver, :force => true
    ln_s src, openni2_cellar + '/share/openni2/tools/OpenNI2/Drivers/' + driver, :force => true
    ln_s src, openni2_cellar + '/share/openni2/samples/Bin/OpenNI2/Drivers/' + driver, :force => true
  end
end
