import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const NexusApp());
}

// ─── Data Models ──────────────────────────────────────────────────────────────

class Profile {
  final int id;
  final String name;
  final String role;
  final String location;
  final int mutual;
  final List<String> tags;
  final String initials;
  final Color color;
  final bool verified;
  final bool online;

  const Profile({
    required this.id,
    required this.name,
    required this.role,
    required this.location,
    required this.mutual,
    required this.tags,
    required this.initials,
    required this.color,
    required this.verified,
    required this.online,
  });
}

class Story {
  final String name;
  final String initials;
  final Color color;
  final bool isYou;

  const Story({
    required this.name,
    required this.initials,
    required this.color,
    this.isYou = false,
  });
}

// ─── Mock Data ────────────────────────────────────────────────────────────────

final List<Profile> mockProfiles = [
  Profile(
    id: 1,
    name: 'Aanya Sharma',
    role: 'Product Designer',
    location: 'Mumbai, IN',
    mutual: 12,
    tags: ['Design', 'Figma', 'UX'],
    initials: 'AS',
    color: const Color(0xFFFF6B6B),
    verified: true,
    online: true,
  ),
  Profile(
    id: 2,
    name: 'Leo Nakamura',
    role: 'Full Stack Engineer',
    location: 'Tokyo, JP',
    mutual: 7,
    tags: ['React', 'Node', 'AI'],
    initials: 'LN',
    color: const Color(0xFF4ECDC4),
    verified: false,
    online: true,
  ),
  Profile(
    id: 3,
    name: 'Priya Mehta',
    role: 'Growth Strategist',
    location: 'Kathmandu, NP',
    mutual: 24,
    tags: ['Marketing', 'SEO', 'SaaS'],
    initials: 'PM',
    color: const Color(0xFFA29BFE),
    verified: true,
    online: false,
  ),
  Profile(
    id: 4,
    name: 'Carlos Vega',
    role: 'Venture Capital',
    location: 'São Paulo, BR',
    mutual: 3,
    tags: ['Startups', 'Fintech', 'B2B'],
    initials: 'CV',
    color: const Color(0xFFFD79A8),
    verified: true,
    online: true,
  ),
  Profile(
    id: 5,
    name: 'Zara Ahmed',
    role: 'AI Researcher',
    location: 'London, UK',
    mutual: 18,
    tags: ['ML', 'Python', 'Research'],
    initials: 'ZA',
    color: const Color(0xFF55EFC4),
    verified: false,
    online: false,
  ),
];

final List<Story> mockStories = [
  Story(name: 'Your Story', initials: 'M', color: const Color(0xFF6C63FF), isYou: true),
  Story(name: 'Aanya', initials: 'AS', color: const Color(0xFFFF6B6B)),
  Story(name: 'Leo', initials: 'LN', color: const Color(0xFF4ECDC4)),
  Story(name: 'Priya', initials: 'PM', color: const Color(0xFFA29BFE)),
  Story(name: 'Carlos', initials: 'CV', color: const Color(0xFFFD79A8)),
];

const List<String> notifications = [
  'Leo sent you a connect request',
  'Priya viewed your profile',
  'New mutual: Carlos Vega',
];

// ─── Theme Colors ─────────────────────────────────────────────────────────────

const Color kPrimary   = Color(0xFF6C63FF);
const Color kPrimaryLight = Color(0xFFA29BFE);
const Color kBg        = Color(0xFFF8F7FF);
const Color kCard      = Color(0xFFFFFFFF);
const Color kBorder    = Color(0xFFEFEFFF);
const Color kOnline    = Color(0xFF00C853);
const Color kDark      = Color(0xFF1A1A2E);
const Color kMuted     = Color(0xFF9E9E9E);
const Color kRed       = Color(0xFFFF6B6B);

// ─── Root App ─────────────────────────────────────────────────────────────────

class NexusApp extends StatelessWidget {
  const NexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
        fontFamily: 'sans-serif',
        scaffoldBackgroundColor: kBg,
      ),
      home: const HomePage(),
    );
  }
}

// ─── Home Page ────────────────────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _activeTab = 0;
  bool _showNotif = false;
  final Set<int> _connected = {};
  final Set<int> _liked = {};

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: kBg,
        body: Stack(
          children: [
            Column(
              children: [
                _TopNav(
                  showNotif: _showNotif,
                  onNotifTap: () => setState(() => _showNotif = !_showNotif),
                ),
                Expanded(
                  child: _FeedBody(
                    connected: _connected,
                    liked: _liked,
                    onConnect: (id) => setState(() {
                      _connected.contains(id) ? _connected.remove(id) : _connected.add(id);
                    }),
                    onLike: (id) => setState(() {
                      _liked.contains(id) ? _liked.remove(id) : _liked.add(id);
                    }),
                  ),
                ),
              ],
            ),
            // Notification dropdown overlay
            if (_showNotif)
              Positioned(
                top: MediaQuery.of(context).padding.top + 64,
                right: 16,
                child: _NotifPanel(onDismiss: () => setState(() => _showNotif = false)),
              ),
          ],
        ),
        bottomNavigationBar: _BottomNav(
          activeIndex: _activeTab,
          onTap: (i) => setState(() => _activeTab = i),
        ),
      ),
    );
  }
}

// ─── Top Navigation ───────────────────────────────────────────────────────────

class _TopNav extends StatelessWidget {
  final bool showNotif;
  final VoidCallback onNotifTap;

  const _TopNav({required this.showNotif, required this.onNotifTap});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: kBg,
      padding: EdgeInsets.only(top: top + 8, left: 20, right: 20, bottom: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorder)),
      ),
      child: Row(
        children: [
          // Avatar + greeting
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kPrimary, kPrimaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimary.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('M',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                ),
              ),
              Positioned(
                bottom: 1,
                right: 1,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: kOnline,
                    shape: BoxShape.circle,
                    border: Border.all(color: kBg, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Good morning 👋',
                style: TextStyle(fontSize: 11, color: kMuted, fontWeight: FontWeight.w400)),
              Text('Maya Patel',
                style: TextStyle(fontSize: 15, color: kDark, fontWeight: FontWeight.w700)),
            ],
          ),
          const Spacer(),
          // Bell button
          Stack(
            children: [
              _IconButton(onTap: onNotifTap, child: const Icon(Icons.notifications_outlined, size: 18, color: Color(0xFF555555))),
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: kRed,
                    shape: BoxShape.circle,
                    border: Border.all(color: kBg, width: 1.5),
                  ),
                  child: const Center(
                    child: Text('3', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          _IconButton(
            onTap: () {},
            child: const Icon(Icons.settings_outlined, size: 18, color: Color(0xFF555555)),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _IconButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorder),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}

// ─── Notification Panel ───────────────────────────────────────────────────────

class _NotifPanel extends StatelessWidget {
  final VoidCallback onDismiss;
  const _NotifPanel({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorder),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 30, offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Notifications',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kPrimary)),
            const SizedBox(height: 8),
            ...notifications.map((n) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(n,
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF444444), height: 1.4)),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// ─── Feed Body ────────────────────────────────────────────────────────────────

class _FeedBody extends StatelessWidget {
  final Set<int> connected;
  final Set<int> liked;
  final ValueChanged<int> onConnect;
  final ValueChanged<int> onLike;

  const _FeedBody({
    required this.connected,
    required this.liked,
    required this.onConnect,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        // Search bar
        _SearchBar(),
        const SizedBox(height: 16),
        // Active Now
        _SectionHeader(title: 'Active Now', action: 'See all', onAction: () {}),
        const SizedBox(height: 10),
        _StoriesRow(),
        const SizedBox(height: 16),
        // People you may know
        _SectionHeader(title: 'People You May Know', action: 'Filter', onAction: () {}),
        const SizedBox(height: 10),
        // Profile cards
        ...mockProfiles.map((p) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _ProfileCard(
            profile: p,
            isConnected: connected.contains(p.id),
            isLiked: liked.contains(p.id),
            onConnect: () => onConnect(p.id),
            onLike: () => onLike(p.id),
          ),
        )),
      ],
    );
  }
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: const [
          Icon(Icons.search, size: 16, color: kMuted),
          SizedBox(width: 8),
          Text('Search people, skills, tags…',
            style: TextStyle(fontSize: 13, color: Color(0xFFBBBBBB))),
        ],
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onAction;

  const _SectionHeader({required this.title, required this.action, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kDark)),
        GestureDetector(
          onTap: onAction,
          child: Text(action, style: const TextStyle(fontSize: 11.5, color: kPrimary, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

// ─── Stories Row ──────────────────────────────────────────────────────────────

class _StoriesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mockStories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final s = mockStories[i];
          return _StoryItem(story: s);
        },
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  final Story story;
  const _StoryItem({required this.story});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 54,
                height: 54,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(color: story.color, width: 2.5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: story.color,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Center(
                    child: story.isYou
                        ? const Icon(Icons.add, color: Colors.white, size: 20)
                        : Text(story.initials[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            )),
                  ),
                ),
              ),
              if (!story.isYou)
                Positioned(
                  bottom: 3,
                  right: 3,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: kOnline,
                      shape: BoxShape.circle,
                      border: Border.all(color: kBg, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            story.name,
            style: const TextStyle(fontSize: 10, color: Color(0xFF666666), fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Profile Card ─────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final Profile profile;
  final bool isConnected;
  final bool isLiked;
  final VoidCallback onConnect;
  final VoidCallback onLike;

  const _ProfileCard({
    required this.profile,
    required this.isConnected,
    required this.isLiked,
    required this.onConnect,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0EEFF)),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Accent blob top-right
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    profile.color.withOpacity(0.2),
                    profile.color.withOpacity(0.05),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(80),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: avatar + info + connect
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Stack(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: profile.color,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(profile.initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              )),
                          ),
                        ),
                        if (profile.online)
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 11,
                              height: 11,
                              decoration: BoxDecoration(
                                color: kOnline,
                                shape: BoxShape.circle,
                                border: Border.all(color: kCard, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(profile.name,
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: kDark,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (profile.verified) ...[
                                const SizedBox(width: 5),
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [kPrimary, kPrimaryLight],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Text('✓',
                                      style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(profile.role,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF777777))),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Text('📍', style: TextStyle(fontSize: 10)),
                              const SizedBox(width: 2),
                              Text(profile.location,
                                style: const TextStyle(fontSize: 11, color: kMuted)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Connect button
                    GestureDetector(
                      onTap: onConnect,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          gradient: isConnected
                              ? null
                              : const LinearGradient(
                                  colors: [kPrimary, kPrimaryLight],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          color: isConnected ? Colors.transparent : null,
                          borderRadius: BorderRadius.circular(10),
                          border: isConnected
                              ? Border.all(color: kPrimary, width: 1.5)
                              : null,
                        ),
                        child: Text(
                          isConnected ? 'Connected' : 'Connect',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isConnected ? kPrimary : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Tags + mutual
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ...profile.tags.map((t) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EEFF),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(t,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: kPrimary,
                        )),
                    )),
                    const SizedBox(width: 4),
                    Text('👥 ${profile.mutual} mutual',
                      style: const TextStyle(fontSize: 11, color: kMuted)),
                  ],
                ),
                const SizedBox(height: 10),
                // Divider
                const Divider(color: Color(0xFFF5F4FF), height: 1),
                const SizedBox(height: 8),
                // Action row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _CardAction(
                      icon: isLiked ? '♥' : '♡',
                      iconColor: isLiked ? kRed : kMuted,
                      label: 'Like',
                      onTap: onLike,
                    ),
                    _CardAction(icon: '💬', label: 'Message', onTap: () {}),
                    _CardAction(icon: '↗', label: 'Share', onTap: () {}),
                    _CardAction(icon: '⋯', label: 'More', onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardAction extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const _CardAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          children: [
            Text(icon,
              style: TextStyle(
                fontSize: 16,
                color: iconColor ?? kMuted,
              )),
            const SizedBox(height: 2),
            Text(label,
              style: const TextStyle(fontSize: 10, color: kMuted, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Navigation ────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.activeIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 64 + bottom,
      padding: EdgeInsets.only(bottom: bottom, left: 8, right: 8),
      decoration: BoxDecoration(
        color: kCard,
        border: const Border(top: BorderSide(color: kBorder)),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, index: 0, activeIndex: activeIndex, onTap: onTap),
          _NavItem(icon: Icons.search_outlined, activeIcon: Icons.search, index: 1, activeIndex: activeIndex, onTap: onTap),
          // FAB center button
          GestureDetector(
            onTap: () => onTap(2),
            child: Transform.translate(
              offset: const Offset(0, -10),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kPrimary, kPrimaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimary.withOpacity(0.45),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 26),
              ),
            ),
          ),
          _NavItem(icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, index: 3, activeIndex: activeIndex, onTap: onTap),
          _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, index: 4, activeIndex: activeIndex, onTap: onTap),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final int index;
  final int activeIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.index,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == activeIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? kPrimary : const Color(0xFFBBBBBB),
              size: 22,
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isActive ? 5 : 0,
              height: isActive ? 5 : 0,
              decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
            ),
          ],
        ),
      ),
    );
  }
}