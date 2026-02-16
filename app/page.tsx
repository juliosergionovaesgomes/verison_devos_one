 import Image from "next/image";

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center p-4">
      <div className="max-w-4xl w-full bg-white/95 backdrop-blur-lg rounded-3xl shadow-2xl p-8 md:p-12">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-4xl md:text-6xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent mb-4">
            🚀 Verison DevOps One
          </h1>
          <div className="bg-gradient-to-r from-green-500 to-green-600 text-white px-6 py-4 rounded-2xl font-bold text-lg shadow-lg">
            ✅ Deploy Automático Realizado com Next.js!
            <div className="mt-2 flex flex-wrap justify-center gap-2">
              <span className="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm">🤖 CI/CD Automation</span>
              <span className="bg-purple-100 text-purple-800 px-3 py-1 rounded-full text-sm">🔄 Zero-Touch Deploy</span>
            </div>
          </div>
        </div>

        {/* Pipeline Info */}
        <div className="bg-gradient-to-r from-cyan-50 to-blue-50 border border-cyan-200 rounded-2xl p-6 mb-8">
          <h3 className="text-xl font-bold text-gray-800 mb-3">🎯 Pipeline Next.js Executada Automaticamente!</h3>
          <p className="text-gray-700 mb-4">
            Esta aplicação Next.js foi deployada automaticamente via GitHub Actions, usando export estático para máxima compatibilidade.
          </p>
          <div className="flex flex-wrap gap-2">
            <span className="bg-green-500 text-white px-3 py-1 rounded-full text-sm font-bold">Next.js 16.1.6</span>
            <span className="bg-blue-500 text-white px-3 py-1 rounded-full text-sm font-bold">LocalStack</span>
            <span className="bg-purple-500 text-white px-3 py-1 rounded-full text-sm font-bold">Terraform</span>
            <span className="bg-orange-500 text-white px-3 py-1 rounded-full text-sm font-bold">GitHub Pages</span>
          </div>
        </div>

        {/* Info Grid */}
        <div className="grid md:grid-cols-2 gap-6 mb-8">
          {/* Deployment Info */}
          <div className="bg-gray-50 rounded-2xl p-6 border-l-4 border-blue-500">
            <h3 className="text-lg font-bold text-gray-800 mb-4">📋 Deployment Information</h3>
            <div className="space-y-2 text-sm">
              <div>🌍 <strong>Environment:</strong> Multi-Platform</div>
              <div>🪣 <strong>S3 Bucket:</strong> verison-devos-one-website</div>
              <div>🌎 <strong>Region:</strong> us-east-1</div>
              <div>⚡ <strong>Framework:</strong> Next.js 16.1.6</div>
              <div>🏗️ <strong>Infrastructure:</strong> Terraform</div>
              <div>📅 <strong>Build:</strong> Static Export</div>
            </div>
          </div>

          {/* Deployment Targets */}
          <div className="bg-gray-50 rounded-2xl p-6 border-l-4 border-green-500">
            <h3 className="text-lg font-bold text-gray-800 mb-4">🔧 Deployment Targets</h3>
            <div className="space-y-2 text-sm">
              <div>🐳 <strong>LocalStack:</strong> S3 Static Hosting</div>
              <div>📄 <strong>GitHub Pages:</strong> Static Website</div>
              <div>🏥 <strong>Health Checks:</strong> Automated</div>
              <div>🔍 <strong>Verification:</strong> CI/CD Pipeline</div>
              <div>📊 <strong>Monitoring:</strong> GitHub Actions</div>
              <div>🚀 <strong>Status:</strong> <span className="text-green-600 font-bold">Live & Running</span></div>
            </div>
          </div>
        </div>

        {/* Tech Stack */}
        <div className="bg-gray-50 rounded-2xl p-6 mb-8">
          <h3 className="text-lg font-bold text-gray-800 mb-4">🛠️ Technology Stack</h3>
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
            {[
              { emoji: "⚡", name: "Next.js", desc: "React Framework" },
              { emoji: "🐳", name: "LocalStack", desc: "AWS Emulation" },
              { emoji: "🪣", name: "S3", desc: "Static Hosting" },
              { emoji: "🏗️", name: "Terraform", desc: "Infrastructure as Code" },
              { emoji: "🚀", name: "GitHub Actions", desc: "CI/CD Pipeline" },
              { emoji: "📄", name: "GitHub Pages", desc: "Static Hosting" },
            ].map((tech, index) => (
              <div key={index} className="bg-white rounded-xl p-4 text-center shadow-sm hover:shadow-md transition-shadow">
                <div className="text-2xl mb-2">{tech.emoji}</div>
                <div className="font-bold text-gray-800 text-sm">{tech.name}</div>
                <div className="text-xs text-gray-600">{tech.desc}</div>
              </div>
            ))}
          </div>
        </div>

        {/* Quick Links */}
        <div className="bg-gray-50 rounded-2xl p-6 mb-8">
          <h3 className="text-lg font-bold text-gray-800 mb-4">🔗 Quick Links</h3>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {[
              { 
                href: "https://github.com/juliosergionovaesgomes/verison_devos_one", 
                icon: "📂", 
                text: "Repository" 
              },
              { 
                href: "https://github.com/juliosergionovaesgomes/verison_devos_one/actions", 
                icon: "🔄", 
                text: "GitHub Actions" 
              },
              { 
                href: "http://localhost:4566/_localstack/health", 
                icon: "🏥", 
                text: "LocalStack Health" 
              },
              { 
                href: "http://localhost:4566/_localstack/cockpit", 
                icon: "🎛️", 
                text: "LocalStack Dashboard" 
              },
            ].map((link, index) => (
              <a 
                key={index}
                href={link.href} 
                target="_blank" 
                rel="noopener noreferrer"
                className="bg-white rounded-xl p-4 text-center shadow-sm hover:shadow-md transition-all hover:scale-105 block text-blue-600 font-bold"
              >
                <div className="text-xl mb-1">{link.icon}</div>
                <div className="text-sm">{link.text}</div>
              </a>
            ))}
          </div>
        </div>

        {/* Highlight */}
        <div className="bg-gradient-to-r from-cyan-100 to-purple-100 rounded-2xl p-6 text-center mb-8">
          <h3 className="text-xl font-bold text-gray-800 mb-3">🎉 Pipeline DevOps Completa com Next.js!</h3>
          <p className="text-gray-700 mb-2">
            <strong>✨ Zero-Touch Deployment:</strong> Do código ao website online, tudo automatizado!
          </p>
          <p className="text-gray-700 mb-2">
            <strong>🔒 Multi-Platform:</strong> LocalStack para desenvolvimento + GitHub Pages para produção.
          </p>
          <p className="text-gray-700">
            <strong>🚀 Infrastructure as Code:</strong> Terraform + Next.js Static Export.
          </p>
        </div>

        {/* Footer */}
        <div className="text-center text-gray-600">
          <p className="mb-2">💎 Desenvolvido com ❤️ usando Next.js + GitHub Actions + LocalStack + Terraform</p>
          <p className="text-sm">
            🌟 Pipeline DevOps totalmente automatizada com Next.js Static Export
          </p>
          <div className="mt-4 text-xs">
            <span className="bg-gray-200 px-2 py-1 rounded mr-2">🤖 Automation: 100%</span>
            <span className="bg-gray-200 px-2 py-1 rounded mr-2">🏆 Zero-Touch: ✅</span>
            <span className="bg-gray-200 px-2 py-1 rounded">📊 Multi-Environment: ✅</span>
          </div>
        </div>
      </div>
    </div>
  );
}
