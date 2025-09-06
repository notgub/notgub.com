export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-pink-100 via-purple-100 to-blue-100 animate-gradient-x flex items-center justify-center p-8 relative overflow-hidden">
      {/* Animated background elements */}
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute -top-40 -right-40 w-80 h-80 bg-gradient-to-br from-pink-200 to-purple-200 rounded-full opacity-60 animate-pulse"></div>
        <div className="absolute -bottom-40 -left-40 w-96 h-96 bg-gradient-to-br from-blue-200 to-purple-200 rounded-full opacity-40 animate-bounce"></div>
        <div className="absolute top-1/2 left-1/4 w-32 h-32 bg-gradient-to-br from-purple-200 to-pink-200 rounded-full opacity-50 animate-ping"></div>
        <div className="absolute top-1/4 right-1/4 w-24 h-24 bg-gradient-to-br from-blue-200 to-pink-200 rounded-full opacity-60 animate-pulse"></div>
      </div>
      
      <main className="text-center space-y-6 relative z-10">
        <h1 className="text-7xl md:text-8xl font-light tracking-tight text-slate-900 hover:scale-105 transition-transform duration-300 cursor-default">
          notgub
        </h1>
        <div className="w-24 h-0.5 bg-slate-300 mx-auto animate-pulse"></div>
        <p className="text-lg text-slate-600 font-light tracking-wide hover:text-slate-800 transition-colors duration-300">
          .com
        </p>
        
        {/* Floating particles */}
        <div className="absolute inset-0 pointer-events-none">
          <div className="absolute top-20 left-20 w-2 h-2 bg-pink-300 rounded-full animate-bounce"></div>
          <div className="absolute top-32 right-32 w-1 h-1 bg-purple-300 rounded-full animate-ping"></div>
          <div className="absolute bottom-20 left-32 w-1.5 h-1.5 bg-blue-300 rounded-full animate-pulse"></div>
          <div className="absolute bottom-32 right-20 w-2 h-2 bg-purple-300 rounded-full animate-bounce"></div>
        </div>
      </main>
    </div>
  );
}
